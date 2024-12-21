require "yaml"
require "open-uri"
require "digest"

class Testthingmac < Formula
  desc "DeskThing for Mac - Dynamic Formula Example"
  homepage "https://github.com/ItsRiprod/TestThing"

  # Define a method to fetch and parse the .yml file
  def self.latest_release
    yml_url = "https://github.com/ItsRiprod/TestThing/releases/latest/latest-mac.yml"
    yml_data = YAML.safe_load(URI.open(yml_url).read)

    # Check for x64 file and use it for Intel; default to non-x64 file for ARM
    target_file = if Hardware::CPU.intel?
                    yml_data["files"].find { |file| file["url"].include?("x64") }
                  else
                    yml_data["files"].find { |file| !file["url"].include?("x64") }
                  end

    raise "No suitable file found for this architecture!" unless target_file

    # Compute sha256 dynamically from the provided sha512
    sha256 = Digest::SHA256.hexdigest([target_file["sha512"]].pack("m0"))

    {
      version: yml_data["version"],
      url: "https://github.com/ItsRiprod/TestThing/releases/download/v#{yml_data['version']}/#{target_file['url']}",
      sha256: sha256
    }
  end

  # Dynamically fetch the latest release details
  release = latest_release
  url release[:url]
  sha256 release[:sha256]
  version release[:version]

  license "Proprietary"

  def install
    # Extract the zip archive
    system "unzip", cached_download, "-d", "DeskThingExtracted"

    # Move the .app to the prefix directory
    app_path = Dir["DeskThingExtracted/*.app"].first
    raise "Application not found in extracted zip archive!" unless app_path
    prefix.install app_path
  end

  def caveats
    <<~EOS
      DeskThing.app was installed to:
        #{opt_prefix}/DeskThing.app

      To use it, you may need to move it to /Applications:
        mv #{opt_prefix}/DeskThing.app /Applications
    EOS
  end

  test do
    assert_predicate prefix/"DeskThing.app", :exist?, "DeskThing.app was not installed to the prefix directory"
  end
end

