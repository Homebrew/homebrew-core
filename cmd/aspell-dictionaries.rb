# typed: strict
# frozen_string_literal: true

require "abstract_command"
require "resource"
require "formula"

module Homebrew
  module Cmd
    class AspellDictionariesCmd < AbstractCommand
      cmd_args do
        usage_banner <<~EOS
          `aspell-dictionaries`

          Generates the new dictionaries for the `aspell` formula.
        EOS
      end

      sig { override.void }
      def run
        dictionary_url = "https://ftpmirror.gnu.org/gnu/aspell/dict"
        dictionary_mirror = "https://ftp.gnu.org/gnu/aspell/dict"
        languages = {}

        index_output = Utils::Curl.curl_output("#{dictionary_url}/0index.html").stdout
        index_output.split("<tr><td>").each do |line|
          next unless line.start_with?("<a ")

          _, language, _, path, = line.split('"')
          language&.tr!("-", "_")
          languages[language] = path if language && path
        end

        resources = languages.map do |language, path|
          r = Resource.new(language)
          r.owner = Formula["aspell"]
          r.url "#{dictionary_url}/#{path}"
          r.mirror "#{dictionary_mirror}/#{path}"
          r
        end

        output = resources.map do |resource|
          resource.fetch(verify_download_integrity: false)

          <<-EOS
            resource "#{resource.name}" do
              url "#{resource.url}"
              mirror "#{resource.mirrors.first}"
              sha256 "#{resource.cached_download.sha256}"
            end

          EOS
        end

        puts output
      end
    end
  end
end
