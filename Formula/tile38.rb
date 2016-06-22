require "language/go"

class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "http://tile38.com"
  url "https://github.com/tidwall/tile38/archive/1.2.0.tar.gz"
  sha256 "8797cfe8ad0f787cc00c26a863329090a929257d9f5c5d8d20c17f05234cb2a5"

  head "https://github.com/tidwall/tile38.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f00cfa2e71a0d50c6952e4d10e43739d7ce1bb7e36b25aed1661ea2757154386" => :el_capitan
    sha256 "046b5f1d19467da9c203b7c10707e998185379046136f7c766d06b6d18dfc890" => :yosemite
    sha256 "dc9c289062aae3475809346adf80dbf4840aea46e28634b049367fb9211b6d92" => :mavericks
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
