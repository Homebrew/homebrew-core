class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.31.5.tar.gz"
  sha256 "8ee12e5bedf7ff8f67bbed173a5a08a1aadb27a6256479b2cf4abed982b2a780"

  bottle do
    cellar :any_skip_relocation
    sha256 "1456e170eaa4f6b095664689bf53de0619eb7a1b133ba5d441be91213d47575b" => :mojave
    sha256 "3f756eb9c3c10dcb05965ab616ac38d54945a266096e53cb8e36da4d8a53a4cf" => :high_sierra
    sha256 "918c4bffb20d8c3a28ec46404b5cbd2df6f17b28a65908df21470842e61dc7d5" => :sierra
    sha256 "9ef68bba42b2dc440b3f7ce1407171a2031365a2c768d3aee82ba00ae0226ebf" => :el_capitan
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
