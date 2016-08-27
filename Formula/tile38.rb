class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "http://tile38.com"
  url "https://github.com/tidwall/tile38/archive/1.4.1.tar.gz"
  sha256 "62522bf887c2b96a62d7596b48a2d140b458f44ebf62d52825b9e7b80be4e623"

  head "https://github.com/tidwall/tile38.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "be2ea5d7e7ab73b1f67bb012cf3d8bbd8d7723f71be94acf8593a2fd66991869" => :el_capitan
    sha256 "6b09975e9d4cc6c6e202685419367ddab9e3200d054d674fe86f8f65d1fd9d7b" => :yosemite
    sha256 "e5994fb02e94939b1976fe9d87a2c1ef71e0f6fbdc61239cba27a538d54e28bd" => :mavericks
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
