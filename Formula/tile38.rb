class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "http://tile38.com"
  url "https://github.com/tidwall/tile38/archive/1.11.1.tar.gz"
  sha256 "e5eac0cb54eae755ccf88463985bdd5f0e30c7575d9793f0427e5eae1257e134"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f599ed5e984d370a1a57476cafcc53a5fd46eca4ed91e953632d4ab64e4dcb1a" => :high_sierra
    sha256 "4781e8b1782f0dfd1b30834db0c4e0072998a129edcc9e9d6db62592f7fe1458" => :sierra
    sha256 "f20e835db4787e1504a4457078cb22e1c0b337a9a85281b5bc12aced1edbe590" => :el_capitan
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
