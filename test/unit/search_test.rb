require 'test_helper'

class TestSearch < ActiveSupport::TestCase
  test '#search queries ElasticSearch with the given term, and returns the matching models' do
    protected_area = FactoryGirl.create(:protected_area)
    country = FactoryGirl.create(:country)

    search_query = "manbone"

    query_object = {
      index: 'protected_areas',
      body: {
        size: 20.0,
        from: 0.0,
        query: {
          "bool" => {
            "must" => {
              "bool" => {
                "should" => [
                  { "nested" => { "path" => "countries_for_index", "query" => { "multi_match" => { "query" => search_query, "fields" => [ "countries_for_index.name" ], "fuzziness" => "AUTO" } } } },
                  { "nested" => { "path" => "countries_for_index.region_for_index", "query" => { "multi_match" => { "query" => search_query, "fields" => [ "countries_for_index.region_for_index.name" ], "fuzziness" => "AUTO" } } } },
                  { "nested" => { "path" => "sub_location", "query" => { "multi_match" => { "query" => search_query, "fields" => [ "sub_location.english_name" ], "fuzziness" => "AUTO" } } } },
                  { "nested" => { "path" => "designation", "query" => { "multi_match" => { "query" => search_query, "fields" => [ "designation.name" ], "fuzziness" => "AUTO" } } } },
                  { "nested" => { "path" => "iucn_category", "query" => { "multi_match" => { "query" => search_query, "fields" => [ "iucn_category.name" ], "fuzziness" => "AUTO" } } } },
                  { "nested" => { "path" => "governance", "query" => { "multi_match" => { "query" => search_query, "fields" => [ "governance.name" ], "fuzziness" => "AUTO" } } } },
                  {"terms" => {"wdpa_id" => []}},
                  {
                    "function_score" => {
                      "query" => {
                        "multi_match" => {
                          "query" => "*manbone*",
                          "fields" => [ "name", "original_name" ]
                        }
                      },
                      "boost" => "5",
                      "functions" => [{
                          "filter" => {"match" => {"type" => "country"}},
                          "weight" => 20
                        }, {
                          "filter" => {"match" => {"type" => "region"}},
                          "weight" => 10
                      }]
                    }
                  }
                ]
              }
            }
          }
        },
        aggs: {
          "type_of_territory" => {
            "terms" => { "field" => "marine" }
          },
          "has_parcc_info" => {
            "terms" => { "field" => "has_parcc_info" }
          },
          "has_irreplaceability_info" => {
            "terms" => { "field" => "has_irreplaceability_info" }
          },
          "country" => {
            "nested" => { "path" => "countries_for_index" },
            "aggs" => { "aggregation" => { "terms" => { "field" => "countries_for_index.id", "size" => 500 } } }
          },
          "region" => {
            "nested" => { "path" => "countries_for_index.region_for_index" },
            "aggs" => { "aggregation" => { "terms" => { "field" => "countries_for_index.region_for_index.id", "size" => 500 } } }
          },
          "designation" => {
            "nested" => { "path" => "designation" },
            "aggs" => { "aggregation" => { "terms" => { "field" => "designation.id", "size" => 500 } } }
          },
          "governance" => {
            "nested" => { "path" => "governance" },
            "aggs" => { "aggregation" => { "terms" => { "field" => "governance.id", "size" => 500 } } }
          },
          "iucn_category" => {
            "nested" => { "path" => "iucn_category" },
            "aggs" => { "aggregation" => { "terms" => { "field" => "iucn_category.id", "size" => 500 } } }
          }
        }
      }
    }

    results_object = {
      "hits" => {
        "hits" => [{
          "_type" => "protected_area",
          "_source" => {
            "id" => protected_area.id
          }
        }, {
          "_type" => "country",
          "_source" => {
            "id" => country.id
          }
        }]
      }
    }

    search_mock = mock()
    search_mock.
      expects(:search).
      with(query_object).
      returns(results_object)
    Elasticsearch::Client.stubs(:new).returns(search_mock)

    results = Search.search(search_query).results
    assert 2, results.length

    returned_protected_area = results.first
    assert_kind_of ProtectedArea, returned_protected_area
    assert_equal   protected_area.id, returned_protected_area.id

    returned_country = results.second
    assert_kind_of Country, returned_country
    assert_equal   country.id, returned_country.id
  end

  test '.aggregations returns all the aggregations' do
    country = FactoryGirl.create(:country)
    expected_aggregations = {
      'country' => {
        model: country.id,
        count: 59
      }
    }

    es_response = {
      'country' => {
        'doc_count'=> 169,
        'aggregation' => {
          'buckets'=> [
            {'key' => country.id, 'doc_count' => 59},
          ]
        }
      }
    }

    search_mock = mock()
    search_mock.stubs(:search).returns(es_response)
    Elasticsearch::Client.stubs(:new).returns(search_mock)

    Search::Aggregation.expects(:parse).returns(expected_aggregations)
    assert_equal expected_aggregations, Search.search('manbone').aggregations
  end

  test '#search, given a search term and a page, offsets the
   Elasticsearch query to correctly paginate' do
    Search::Query.any_instance.stubs(:to_h).returns({})
    Search::Aggregation.stubs(:all).returns({})

    expected_query = {
      size: 20,
      from: 20,
      query: {},
      aggs: {}
    }

    search_mock = mock()
    search_mock.
      expects(:search).
      with(index: 'protected_areas', body: expected_query)
    Elasticsearch::Client.stubs(:new).returns(search_mock)

    Search.search("manbone", page: 2)
  end

  test '.current_page returns the current page number' do
    Search::Query.any_instance.stubs(:to_h).returns({})
    Search::Aggregation.stubs(:all).returns({})

    search_mock = mock()
    search_mock.stubs(:search)
    Elasticsearch::Client.stubs(:new).returns(search_mock)

    page = Search.search("manbone", page: 2).current_page

    assert_equal 2, page
  end

  test '.current_page returns 1 if the current page is not set' do
    Search::Query.any_instance.stubs(:to_h).returns({})
    Search::Aggregation.stubs(:all).returns({})

    search_mock = mock()
    search_mock.stubs(:search)
    Elasticsearch::Client.stubs(:new).returns(search_mock)

    page = Search.search("manbone").current_page

    assert_equal 1, page
  end

  test '.total_pages returns the total number of results pages' do
    Search::Query.any_instance.stubs(:to_h).returns({})
    Search::Aggregation.stubs(:all).returns({})

    search_mock = mock()
    search_mock.stubs(:search).returns({"hits" => {"total" => 400}})
    Elasticsearch::Client.stubs(:new).returns(search_mock)

    pages = Search.search("manbone").total_pages

    assert_equal 20, pages
  end
end
