class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.27.7.tar.gz"
  sha256 "0c3bdae8623f9d78f59cf63589fb2d4bcbdc5519dd402127620a43d60b8b1442"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1ffa1cabfca7640f10be90d2b71ee16b780649aa502c15ce365818ce86a0abc" => :high_sierra
    sha256 "26183c7bc0a78debe7b9fc05184add4cd5961ace3a83a647b9fe994a4f5177a5" => :sierra
    sha256 "d895895e00b678c4fa34f3e7740771408dffadd378d48634f97abece1ff4f4f0" => :el_capitan
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
