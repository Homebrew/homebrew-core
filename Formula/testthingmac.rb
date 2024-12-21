require "json"
require "open-uri"
require "digest"

class Testthingmac < Formula
  desc "DeskThing for Mac - Dynamic Formula Example"
  homepage "https://github.com/ItsRiprod/TestThing"

  # Use GitHub API to find the latest release and fetch the .yml file
  def self.latest_release
    api_url = "https://api.github.com/repos/ItsRiprod/TestThing/releases/latest"
    release_data = JSON.parse(URI.open(api_url).read)

    # Find the .yml asset in the release assets
    yml_asset = release_data["assets"].find { |asset| asset["name"].include?("latest-mac.yml") }
    raise "YML file not found in latest release assets!" unless yml_asset

    # Fetch the .yml file
    yml_url = yml_asset["browser_download_url"]
    yml_data = YAML.safe_load(URI.open(yml_url).read)

    # Determine the correct file for the architecture
    architecture = Hardware::CPU.intel? ? "x64" : "mac"
    target_file = yml_data["files"].find { |file| file["url"].include?(architecture) }
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

