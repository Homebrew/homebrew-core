require "language/go"

class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "http://tile38.com"
  url "https://github.com/tidwall/tile38/archive/1.2.0.tar.gz"
  sha256 "8797cfe8ad0f787cc00c26a863329090a929257d9f5c5d8d20c17f05234cb2a5"

  head "https://github.com/tidwall/tile38.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "05d778a3e44781c7681e73847847a33e373faaa86e268e86e594984819840622" => :el_capitan
    sha256 "62ef765927294f869cd25066bcb5ffb20f11c596dbf717f7f1b8b6a64ab0c5ca" => :yosemite
    sha256 "7d10a5fc1d024880397838888e677d95cb2396c1b413794c7162c353878199b2" => :mavericks
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
