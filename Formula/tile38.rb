class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "http://tile38.com"
  url "https://github.com/tidwall/tile38/archive/1.4.2.tar.gz"
  sha256 "3d4e76e4bfdad8c6f69f787c4b4dbe98e446d26df17ca58af6934b06a8545107"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "37b69850f2a2b051514b7fe2b7f5cea129a6e380df0d32d8ddeaf974c8f52af3" => :sierra
    sha256 "4589b978e8c3fe2fba7584543bf911a7d3b34ae077c882633375a3070f743918" => :el_capitan
    sha256 "dde5c61b297fdf69834b92b64105450d5e56500bffd5d75fca2ccc21a8754d72" => :yosemite
    sha256 "c3c28dacfdc6813e44cf39ab93435e4352dbf11517ddf80ad1184eb1b0be35c3" => :mavericks
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
