class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.28.0.tar.gz"
  sha256 "2191c3088bb3bca070b78bc1e5a02363194f6a8b3d6730a7c06e39789cbe730e"

  bottle do
    cellar :any_skip_relocation
    sha256 "c04ac9aedab5a6059a0522b1f68107503138af74879129438c3d2ca0be9baf79" => :high_sierra
    sha256 "26a9d355ef3ea06b68f7ae06f08ad1a597c5dedb8ca751a02b5c9aee3ffb826c" => :sierra
    sha256 "069065c2ab310890856e9ff0381a14da0365482c8e4bcfcbac84792528355eb5" => :el_capitan
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
