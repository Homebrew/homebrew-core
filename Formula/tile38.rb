class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "http://tile38.com"
  url "https://github.com/tidwall/tile38/archive/1.6.0.tar.gz"
  sha256 "377f5fe17674ed3d4dfe099ec460a5c34d8ba5895ecb66d831c5b28d81bd99ad"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ceb67402df80c60f1df9fddbf139dad61cf1bce2de43581c15a1e4b10b916aa" => :sierra
    sha256 "f796b68c742d89d2bec3ad5e318e52f4c99a7d9c403468a86160562f4ba5ef4b" => :el_capitan
    sha256 "8ceb1cf445182d0bbea9fe84e02c8b13295c813d9740650ee194472d039e0020" => :yosemite
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
