class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "http://tile38.com"
  url "https://github.com/tidwall/tile38/archive/1.10.1.tar.gz"
  sha256 "b475e9e764eb2cba69d5bd9c9c083f7e17e86987c9f856a75ca746a1ab814bf6"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "461e4b3d1caa45477c5d6716d0cdaec7434c6a3bdf7d4118406c637b80b52d34" => :high_sierra
    sha256 "14ce99763ab41a757ea15c89ffcb87a876c30a67919c89c5efd46be9dc88333d" => :sierra
    sha256 "56e3a198d2091e43aafed5b1d272f9a0a895ba93ba5b635936bb301381c08ea9" => :el_capitan
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
