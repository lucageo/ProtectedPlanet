class Wdpa::ProtectedAreaImporter
  PARCC_IMPORT = {
    path: Rails.root.join('lib/data/seeds/parcc_info.csv'),
    field: :has_parcc_info
  }
  IRREPLACEABILITY_IMPORT = {
    path: Rails.root.join('lib/data/seeds/irreplaceability_info.csv'),
    field: :has_irreplaceability_info
  }

  def self.import wdpa_release
    Wdpa::ProtectedAreaImporter::AttributeImporter.import wdpa_release
    Wdpa::ProtectedAreaImporter::GeometryImporter.import wdpa_release
    Wdpa::ProtectedAreaImporter::AssetImporter.import

    Wdpa::ProtectedAreaImporter::RelatedSourceImporter.import(PARCC_IMPORT)
    Wdpa::ProtectedAreaImporter::RelatedSourceImporter.import(IRREPLACEABILITY_IMPORT)
  end
end
