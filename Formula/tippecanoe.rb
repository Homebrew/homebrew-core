class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.16.3.tar.gz"
  sha256 "ccc11f27bf3f50dbe0a41496474398e9a72c8fd792e7177550eb04b1740e09eb"

  bottle do
    cellar :any_skip_relocation
    sha256 "a968036a042452e540c7ae8a8264474e5e86e847e037b51e85b240e4b32be386" => :sierra
    sha256 "6b801f25441ac280b98de968df395a7cad2c71298131b9de2f37b4cd3c3bad0b" => :el_capitan
    sha256 "74658a3556a7dd3d992ef936cf64357f5bcb1272f7ed241404c5d88bc1c1de27" => :yosemite
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.json").write <<-EOS.undent
      {"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0]}}
    EOS
    safe_system "#{bin}/tippecanoe", "-o", "test.mbtiles", "test.json"
    assert File.exist?("#{testpath}/test.mbtiles"), "tippecanoe generated no output!"
  end
end
