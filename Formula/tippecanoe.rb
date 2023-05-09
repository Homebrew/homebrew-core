class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.26.0.tar.gz"
  sha256 "6f38a94f166d5cc975b675055ebe15b7368ac52d91eb00a9a643eef700d0b8bc"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "119f9bd3c378878a8ff87591ccc186631e191f7791be9663dd6a76538e2c69e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b99bf2b8791ef9ec143a2cc4f695b9e5ddfae15c8324f099577d56963308167"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7dc63f8454053f0097c63f28a299ce0d02c54058b9563bf7e4528b1652b7319a"
    sha256 cellar: :any_skip_relocation, ventura:        "4f6e6f32740bf303900cd377694c5548a95c19cfc2a2dd1937177e2718035b42"
    sha256 cellar: :any_skip_relocation, monterey:       "a43f323aecef37879675de885e1f1ab8681b10351d4251b9a5d12e9e1e60283f"
    sha256 cellar: :any_skip_relocation, big_sur:        "722cf5cf83d0c800f416dad0879d37704800deb66271b933decd951c6a51d48e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f821ca85743d30515e5014d4fe50cd9b1f7607fc4738fd9ba7fcdaf3580ec13d"
  end

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
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
