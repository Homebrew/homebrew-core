class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "http://tile38.com"
  url "https://github.com/tidwall/tile38/archive/1.9.0.tar.gz"
  sha256 "2e33d1e281a265d6a068efaad1b2a5664e322e2ccf2f7df0a4c872d7c0731d9c"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7077bb135e296269d31035c69ba73465e72deb3ff2607150e231963c709bcdc8" => :sierra
    sha256 "353d426a97ff7b9cbf43be1ff2c0bdf47a3c841469f9d6f1d63ea87df5a4536f" => :el_capitan
    sha256 "daafadd093890fdd39802a41e2f13fb0dfc7e9507bf549577d23e85f23332e3d" => :yosemite
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
