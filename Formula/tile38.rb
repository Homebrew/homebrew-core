class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "http://tile38.com"
  url "https://github.com/tidwall/tile38/archive/1.9.0.tar.gz"
  sha256 "2e33d1e281a265d6a068efaad1b2a5664e322e2ccf2f7df0a4c872d7c0731d9c"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c234ac1a7cbee3669631cbbcf7d243e4ae2c116e4d7f204177f880b6b9101a3a" => :sierra
    sha256 "dafea121a50b1832d59590b6ba18ecda3606b0ad3a6501674a9868e216893da3" => :el_capitan
    sha256 "f2cddeed8413c65e0f3a2af26d46d2581b819f01f895ef3bd9b3701afde92e99" => :yosemite
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
