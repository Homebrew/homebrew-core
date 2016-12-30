class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "http://tile38.com"
  url "https://github.com/tidwall/tile38/archive/1.7.0.tar.gz"
  sha256 "9fb4d308a2399cfc419e03a8182f201387d6585c1c31e99ecf91bbe79b729673"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ab3767876dac3fd80e8df0d56c39a81ea3fd32418a15c8a55c8e4fb82d41ee8" => :sierra
    sha256 "52f3b124e50e333bab51cc9c4d2032f41c77f1f3276ed824f86aa14840eed247" => :el_capitan
    sha256 "32ff02d6a3f0872f4fd335542fa17fe326c705624cabc95ef7cb5c46ad4d341d" => :yosemite
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
