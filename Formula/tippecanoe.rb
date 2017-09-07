class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.24.0.tar.gz"
  sha256 "49ed2214bb0eb50b312e428f102599061734323f38f8cad1c896e4aec2380903"

  bottle do
    cellar :any_skip_relocation
    sha256 "990da3bcaba030ec5d81cc50f92928e3eb86b205814670b127368cc7807c9d97" => :sierra
    sha256 "73c759c57da4a30b95269c19f323550d476eb754b23da19ebb6db21542ba1446" => :el_capitan
    sha256 "9f3870843069adbd1bfe41aa326bdfd164268ce069b19eae357687a1cf592348" => :yosemite
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
