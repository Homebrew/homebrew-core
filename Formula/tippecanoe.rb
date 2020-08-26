class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.36.0.tar.gz"
  sha256 "0e385d1244a0d836019f64039ea6a34463c3c2f49af35d02c3bf241aec41e71b"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e8caa72c197b02617da5b5867ba3c67c208e59d92aba074914958274eee57e5" => :catalina
    sha256 "1432b2d4ad11132cdb97dde0b77ccb3c95de1556a2852d9911e7978222fa9555" => :mojave
    sha256 "a1c78f268f0e54f6856f9e6be6dd9225d2f79ef0fc6905b60d69ef53fd542828" => :high_sierra
  end

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

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
