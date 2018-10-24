class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.32.1.tar.gz"
  sha256 "289e214f0d33b39871799efacdb4ae61f6e272705baa9e9997676b764ef540f2"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1bad986192a9e43c9e1808ae885069e71441a318b196870ca99438fa49c01ad" => :mojave
    sha256 "6116e2441029fade55e2933aa33c5a5bf997f521813753caf383a2c9d593c4ae" => :high_sierra
    sha256 "00d1d34767b9cab72a7d81eb033fc65c4709f08850234a55279cf0ebf5f5de9e" => :sierra
  end

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
