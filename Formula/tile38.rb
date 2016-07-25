class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "http://tile38.com"
  url "https://github.com/tidwall/tile38/archive/1.3.0.tar.gz"
  sha256 "2ca54a9cc4de7ea062da36682054efc8fceb78bb5631ee6d95279ca129094c84"

  head "https://github.com/tidwall/tile38.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "445c8591d211c0838f6bd6388159b50dd1f176db0b49ed46743d740ca2fd0c92" => :el_capitan
    sha256 "33bdc43f75cb86d2be9a70c87aef2221c355ddae2209e92552aae45e797526f1" => :yosemite
    sha256 "58788b124bce42ebae8cbb6ece1d0716f3cb33767c7b6c02b4d6bd1a616ce521" => :mavericks
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
