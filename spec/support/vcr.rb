require 'vcr'

VCR.configure do |c|
  c.default_cassette_options = {
      record: :new_episodes # use :all to re-record
  }
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
end

RSpec.configure do |config|
  module VCRHelpers
    def record_with_vcr(name = sanitize_filename(example.full_description), &block)
      VCR.use_cassette name, &block
    end

    private

    def sanitize_filename(filename)
      filename.strip do |name|
        # NOTE: File.basename doesn't work right with Windows paths on Unix
        # get only the filename, not the whole path
        name.gsub!(/^.*(\\|\/)/, '')

        # Strip out the non-ascii character
        name.gsub!(/[^0-9A-Za-z.\-]/, '_')
      end
    end
  end

  config.include VCRHelpers
end