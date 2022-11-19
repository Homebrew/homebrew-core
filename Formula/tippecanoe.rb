class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.13.0.tar.gz"
  sha256 "c2401520b43c99dd6f6db361acf3e5c8c309caebf5e1a14d98dc416c3ef61ec9"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93eaa6ea109e94cd004747c547615cd2b56bca65506b521d92d446c3208e749a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6950faa4dd5c42f8af8be5ba7f234db977fc80c9ada54bae0ab7d0d05d721410"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04dc87ad0d02b6cbba8e20397443561a72dd16fabe297ba6e2dcb633c5e2d97d"
    sha256 cellar: :any_skip_relocation, monterey:       "f91b28e5978b9bda8f55eaec39eced2051b93f185d84964b98b9198c3ac224be"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b139b7456e3d0b128009b43c3fa989c08899cc9290ae4403acf123cda75ebbc"
    sha256 cellar: :any_skip_relocation, catalina:       "9e0be2b2a45d1bc817ea6014a0a63ee99308c1f56457a9c4d73c5a620bfb6270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8c9279260a6477180e417ccd0714606cfb6c048afede80bab3060aad210e43d"
  end

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.json").write <<~EOS
      {"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0]}}
    EOS
    safe_system "#{bin}/tippecanoe", "-o", "test.mbtiles", "test.json"
    assert_predicate testpath/"test.mbtiles", :exist?, "tippecanoe generated no output!"
  end
end
