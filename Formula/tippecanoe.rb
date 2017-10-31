class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.26.3.tar.gz"
  sha256 "2609bee9f5992f45754b50e4743116a6b8ecb5e16628c635ec3beaf41ffaabcb"

  bottle do
    cellar :any_skip_relocation
    sha256 "1924b8e90000ed7e3f0d83dc8dfb7145d29c3b9fd9e921b00d5c3aa8d28a5974" => :high_sierra
    sha256 "705604bdf1f5e7338300ed98be289201de98f3481de6c327f9745b1727b4ff07" => :sierra
    sha256 "5a471eacd877fc4bab86cd130da6d3d88ae22a8058eae58181d9740b9daf6764" => :el_capitan
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
