class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.27.6.tar.gz"
  sha256 "31bd646404317454378786b762ee45b7f124893e7d08b369cff13e2f22d22b51"

  bottle do
    cellar :any_skip_relocation
    sha256 "a3514414edd1abb08d100b7f0981a4c295f4bb8d7b91aae84050c9bba5aab2cb" => :high_sierra
    sha256 "01e4733b96f2b9dee46fb4fa5bd3c35c7cf9a2ad28b880476439d18f0ea52a70" => :sierra
    sha256 "c8b2a29d9fa6658bdd9ee1c8e0d6d0a280b7f66fcc3250485253187e5109e927" => :el_capitan
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
