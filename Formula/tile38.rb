class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "http://tile38.com"
  url "https://github.com/tidwall/tile38/archive/1.7.0.tar.gz"
  sha256 "9fb4d308a2399cfc419e03a8182f201387d6585c1c31e99ecf91bbe79b729673"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    sha256 "a78aa235236ff05c2fbeddc7e9ea1e4531d80ac93226874b3a10dc8f63016782" => :sierra
    sha256 "b3bf08d321fa75356464bc1413ff823e706fa99d2437da9b7bb74b000b004b66" => :el_capitan
    sha256 "85d93106416d379bb5d997b2b6dcac6ae40fc3d49585abda375c795d63186bc3" => :yosemite
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

  def caveats; <<-EOS.undent
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
