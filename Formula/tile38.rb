class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "http://tile38.com"
  url "https://github.com/tidwall/tile38/archive/1.8.0.tar.gz"
  sha256 "ac970c75e97c7d066f96c0e528083db775c7804bf03045d2c95fb1c462c6d6bb"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    sha256 "0e17d1bdd00ee810ec9ad6e26e507985877838b22c7ff237ce1b73d8872af0f5" => :sierra
    sha256 "176f578c204d1a80c0ffdf0fd91d3c85a65b4e7ed7e44a7a5578f8ddf9e971be" => :el_capitan
    sha256 "a26ab545db5d385ed8dcee91556b9e173629943036a38c7e54f05d767f4cfb6a" => :yosemite
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
