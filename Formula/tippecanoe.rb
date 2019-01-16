class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.32.10.tar.gz"
  sha256 "adbf6bbe67f57ecb9bee9dc9cb313c0564a8745912f1febd061da3036341edaa"

  bottle do
    cellar :any_skip_relocation
    sha256 "0743af42ed2f0908232f1b813af8b4faf37a8f25e9abd8a341d0628e7e974c37" => :mojave
    sha256 "bdaa75b7f76b8cb3e6327e0c7413926151087e4518664d9b1894058642370c8f" => :high_sierra
    sha256 "34b90621908d81c59c2c60d7dbd62abcfdf9607b257605c0f5a81c12d8f774f4" => :sierra
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
