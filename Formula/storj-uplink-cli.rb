class StorjUplinkCli < Formula
  desc "Client-side application that supports CLI interaction with the Storj DCS network"
  homepage "https://github.com/storj/storj/wiki/Uplink-CLI"
  url "https://github.com/storj/storj/releases/latest/download/uplink_darwin_amd64.zip"
  version "1.28.2"
  sha256 "008327bfa1cfda669494ad853fdaaf6f2fab8420d2c0287f8df580d952476bf6"
  license "AGPL-3.0-only"

  def install
    bin.install "uplink"
  end

  def caveats
    "To configure, import your accessgrant key saved as a plain txt file with the command:
      uplink import <accessgrant.txt>"
  end

  test do
    system "#{bin}/uplink"
  end
end
