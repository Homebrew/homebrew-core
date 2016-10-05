class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "http://tile38.com"
  url "https://github.com/tidwall/tile38/archive/1.5.0.tar.gz"
  sha256 "bc01e997528ab4caacf94969d27e735447654db1a93a2f8073650d649733983c"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8b4d1015cd47f3a4917818d74e8accc079162ac7e6ca7d027d78b0ec439fbe5" => :sierra
    sha256 "9c4623e4ee40e4a66f8639574f008cde04f69d8af3c0256829d98a8333396ded" => :el_capitan
    sha256 "0e72d154547879c9f8113a3201f4e54890987f9c3efc8ed4f469d7fe78a82b24" => :yosemite
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
