class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.30.1.tar.gz"
  sha256 "5a2fadf2446a47ad733c78230ae161d665a15eb17a06c2d5e0e3c9b9dbcc35de"

  bottle do
    cellar :any_skip_relocation
    sha256 "348bf6ed553eec690117b0130750fdd0de195a6935dca6b9441ba8ebae88f310" => :high_sierra
    sha256 "fe41fe9d4001fc7bf2f193145531fa46af86050eb06c4dc2ad701780fae30ef3" => :sierra
    sha256 "b6e49146d04e9feb237f9dfb052e32d2186da9af7f5677a2ee1266738725ea70" => :el_capitan
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
