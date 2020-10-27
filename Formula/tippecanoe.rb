class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.36.0.tar.gz"
  sha256 "0e385d1244a0d836019f64039ea6a34463c3c2f49af35d02c3bf241aec41e71b"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "466aeb229f38b9b549931dab6954786651aa62cd874bbd47b9c28cdb0856cb3d" => :catalina
    sha256 "6d5c1d7567f9a1754a93f844fb18168367437dcccbf7fb06efbce5e5ad9a6a56" => :mojave
    sha256 "2e696df5160edb776144d15805d4baff01db61eb8a5b729bdfd2322095808077" => :high_sierra
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
