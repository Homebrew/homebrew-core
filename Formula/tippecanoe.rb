class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.27.8.tar.gz"
  sha256 "bd46aeadeadb0e1da286ae2c14e1519248a91650cfcedbc4ccb6409df84cd490"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba401cc8c778bc3b4d1e86b9c3b562904bf6167fa58ab8a9f3672bd57bc50a8b" => :high_sierra
    sha256 "9905d1283b27efc4ee84ef1bfd62b0a780a78e307d484b8e2d22f7bb7562d361" => :sierra
    sha256 "1407ac09af8858e79cd1f427be3e0e3daee8550e28d3272f254af44052502481" => :el_capitan
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
