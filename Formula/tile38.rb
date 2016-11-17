class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "http://tile38.com"
  url "https://github.com/tidwall/tile38/archive/1.5.3.tar.gz"
  sha256 "b36175b63d047273e3813804ff42b02a9fcf9b449679441b53fb31a42bcd0ae7"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6f2b00fa643b7bf5de918e248a591fc0b6959b90b754bd8ef3bc85d9ad6995f" => :sierra
    sha256 "40786e00c8d2e7d3ed9e8ec5c70aa63a58d3fc4ef0bfa288f0afcf87df77f7f5" => :el_capitan
    sha256 "2c4570491e566ac12476bc405fdaba1b96348fe3e9bee79e2d7fdd48a118a4e0" => :yosemite
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
