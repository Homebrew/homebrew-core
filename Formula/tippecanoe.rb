class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.32.9.tar.gz"
  sha256 "553d63a6385bfedcd4c0736a6b705ca20aa0dbf2bedc0db2e5775d450bfe9fe3"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f5bf2839e1ad6e48646c0b00ba293d30aef4966127e96c9ae120d38f8d1a06f" => :mojave
    sha256 "d2389067a42fefd4bd90681a92bb4c4bd70425d741c0b47849172f1517d6812e" => :high_sierra
    sha256 "f600aef99b96d6300adf8376b10eec208f9dc5839b2a898dfbdec132f6eae8d6" => :sierra
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
