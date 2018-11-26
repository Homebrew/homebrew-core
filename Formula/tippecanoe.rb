class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.32.5.tar.gz"
  sha256 "ad7203b7981513410adae9c39ff0b6bd8d2622c1971f2f6233bdca4c42435b23"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc4e02aa8f8b98493b92b659059c4b946fdcfd97b8b54bd89046dff231fe3e74" => :mojave
    sha256 "00f5a2f541b55d24ec7fd33e5122ac4291bb698eb155edca97f6200f5b1583a6" => :high_sierra
    sha256 "477e22aa488a44c758dbad27dbf5fb7ff6e9bdca04529174db365068bb1c868a" => :sierra
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
