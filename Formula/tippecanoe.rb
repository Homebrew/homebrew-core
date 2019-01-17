class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.32.10.tar.gz"
  sha256 "adbf6bbe67f57ecb9bee9dc9cb313c0564a8745912f1febd061da3036341edaa"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b32bfed56c00841b7fb3896940b2e87431884d651f0b0a08423766b6b2ebf37" => :mojave
    sha256 "cecb1bb4f6aed344e55bb9cb2ab149affdd74b6d211f98d6e89320ef7e0c96ca" => :high_sierra
    sha256 "cc8cd3daac3124b02a53d7b9fe6363472ec374c8b6a10f0699874a80ee28e067" => :sierra
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
