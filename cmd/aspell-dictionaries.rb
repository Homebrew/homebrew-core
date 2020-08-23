require "cli/parser"
require "open-uri"
require "resource"
require "formula"

module Homebrew
  module_function

  def aspell_dictionaries_args
    Homebrew::CLI::Parser.new do
      usage_banner <<~EOS
        `aspell-dictionaries`

        Generates the new dictionaries for the `aspell` formula.
      EOS
    end
  end

  def aspell_dictionaries
    aspell_dictionaries_args.parse

    dict_url    = "https://ftp.gnu.org/gnu/aspell/dict"
    dict_mirror = "https://ftpmirror.gnu.org/aspell/dict"

    languages   = {}

    URI.parse("#{dict_url}/0index.html").open do |content|
      content.each_line do |line|
        break if line.start_with?("</table")
        next unless line.start_with?("<tr><td><a/")

        fields = line.split('"')
        lang = fields[1]
        path = fields[3]
        lang.tr!("-", "_")
        languages[lang] = path
      end
    end

    resources = languages.map do |lang, path|
      r = Resource.new(lang)
      r.owner = Formulary.factory("aspell")
      r.url "#{dict_url}/#{path}"
      r.mirror "#{dict_mirror}/#{path}"
      r
    end

    resources.each { |r| r.fetch(verify_download_integrity: false) }

    resources.each do |r|
      puts <<-EOS
        resource "#{r.name}" do
          url "#{r.url}"
          mirror "#{r.mirrors.first}"
          sha256 "#{r.cached_download.sha256}"
        end

      EOS
    end
  end
end
