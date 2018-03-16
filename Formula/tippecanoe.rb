class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.27.9.tar.gz"
  sha256 "d7b97e3f390e3755cae4ccca149ce3ceb1ee4bdc572a14302e0977e25e8aa410"

  bottle do
    cellar :any_skip_relocation
    sha256 "2a29aab003017d1f9a8b0329117c77d3934d2c1581cf5c4144c05f057f1fc8cb" => :high_sierra
    sha256 "50f441aa097a43b85e926918aef35171c86347ac2ce29a291276976c2d109963" => :sierra
    sha256 "68ff5243621c5449ee29e52f729179e8bbd4d3394495cc53b9339ee806e02ac2" => :el_capitan
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
