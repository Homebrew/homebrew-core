class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.26.3.tar.gz"
  sha256 "2609bee9f5992f45754b50e4743116a6b8ecb5e16628c635ec3beaf41ffaabcb"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b68048853015b2ffaaeceb3f67cc95fcc6865f57546e45717e91fc364da1171" => :high_sierra
    sha256 "dc72ad5887e58f7db703e697e65a98e5c6d330f27f4e036ff2a60c85d82594d1" => :sierra
    sha256 "f9027acbc716e09e806e94a9ac164c3370493915bcfdfe2e7b30b7d7cb638d18" => :el_capitan
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
