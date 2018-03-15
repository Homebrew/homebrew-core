class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "http://tile38.com"
  url "https://github.com/tidwall/tile38/archive/1.11.0.tar.gz"
  sha256 "09c33a73d55a6d9d115d4c7a4f3ba252fa93e87f7cf63fa906db07a4fe023d33"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "67f90f4d90b1c0af906073507870dfdc542971fb76733899a7949c7bdc9679d4" => :high_sierra
    sha256 "62d823d18cc17cb608f123d8beba1fcc0ff1e9cb45710e5b0226367916e049e6" => :sierra
    sha256 "54d67f5ede1b92aa270c153cadfd8c8384a70d1a8075549e09c5cf05135b7aaa" => :el_capitan
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
