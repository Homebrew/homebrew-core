class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "http://tile38.com"
  url "https://github.com/tidwall/tile38/archive/1.5.4.tar.gz"
  sha256 "b8b3cb6566292c57605b4b31799495c9d7ad5bc9d2f3c90b3a0936439c7240e6"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0ae0ae41ee7bbb3980bfb970f3fe5d714f0cb9808d07dbaa7500354c8272ef5" => :sierra
    sha256 "00105b12175925d2e3c58571fb0fcbef88c49ace4fe61778fd7edfb5ce3ccc2d" => :el_capitan
    sha256 "8e26da6b15b79d6d2c6dfcb4240e9fdf263b392326c0e2f685bb741b444b424c" => :yosemite
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
