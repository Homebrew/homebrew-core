class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "http://tile38.com"
  url "https://github.com/tidwall/tile38/archive/1.10.0.tar.gz"
  sha256 "614b91cc1561ac3c491a3a5e1ce7664ae01f94d51567bc7549cf33b1d3da581f"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2d3df688127a085ad14f81dd9cbad43218360b893b58673128c64fbb5708ae3" => :high_sierra
    sha256 "6b50ff3c6d0d7ccc7e4d22947e77795fedeed4dee0bd81b8f8090e6b9cd91791" => :sierra
    sha256 "858bfb5f4b5e4fd3fc8d1e6abbaf11b3d4edc4d7cda9f2c65a207379271f41ff" => :el_capitan
    sha256 "a56ee5e85dc8d70f9cfb83abea0ef41ff0f59b3ffdeb9aaf1203f76b8bea592e" => :yosemite
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

  def caveats; <<~EOS
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
