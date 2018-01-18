class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "http://tile38.com"
  url "https://github.com/tidwall/tile38/archive/1.10.1.tar.gz"
  sha256 "b475e9e764eb2cba69d5bd9c9c083f7e17e86987c9f856a75ca746a1ab814bf6"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "63f6dd71928a7e6d41129980d8335b11b86430812e522c53933af03d4f1b9622" => :high_sierra
    sha256 "b65b850de8fdac152267e657398f8ae3c2e48a56f5f828391497f07cb26b998e" => :sierra
    sha256 "ca068b48eb12c0a8d761faaa51f09362d265ec28066f737bbf34c3f2b5aa81ea" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def datadir
    var/"tile38/data"
  end

  def install
    ENV["GOPATH"] = buildpath
    system "make"

    bin.install "tile38-cli", "tile38-server"
  end

  def post_install
    # Make sure the data directory exists
    datadir.mkpath
  end

  def caveats; <<~EOS
    Data directory created at #{datadir}. To start the server:
        tile38-server -d #{datadir}

    To connect:
        tile38-cli
    EOS
  end

  test do
    system bin/"tile38-cli", "-h"
  end
end
