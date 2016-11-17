class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "http://tile38.com"
  url "https://github.com/tidwall/tile38/archive/1.5.3.tar.gz"
  sha256 "b36175b63d047273e3813804ff42b02a9fcf9b449679441b53fb31a42bcd0ae7"
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
