class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.32.3.tar.gz"
  sha256 "dd5af0b40caf88d7d5503f4b1b0a866e87fdbc2482a2be82c663aa1668ae5a0a"

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
