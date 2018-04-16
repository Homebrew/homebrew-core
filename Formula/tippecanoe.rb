class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.27.13.tar.gz"
  sha256 "35f60a6b934f8db80b7f2433d18dbf1b33887e5681ec1db985a995be68025416"

  bottle do
    cellar :any_skip_relocation
    sha256 "720c9cc62cc38ef9c218339e1d8c345ff2acf9ddb76ce08b34fd3d2b61c4e8ea" => :high_sierra
    sha256 "e3d6b24eff601bf22347bea754d763abfcf363eafef9251d0c53da60a8e8caf6" => :sierra
    sha256 "7f527d7a6579c215d11756400013a0db44a55de64d9618e29d475cf8dd262c09" => :el_capitan
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
