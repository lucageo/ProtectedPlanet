class SearchWorkers::Downloader < SearchWorkers::Base

  def perform token, search_term, options
    self.search_term = search_term
    self.token = token
    self.filters = options['filters']
    @email = options[:email]

    generate_download
    complete_search
  end

  private

  def generate_download
    Download.generate(filename, {wdpa_ids: protected_area_ids})
    send_completion_email
  end

  def send_completion_email
    if @email
      DownloadCompleteMailer.
        create(filename, @email).
        deliver
    end
  end

  def complete_search
    search.properties['filename'] = filename
    search.complete!
  end

  def ids_digest
    Digest::SHA256.hexdigest(protected_area_ids.join)
  end

  def filename
    "search_#{ids_digest}"
  end
end
