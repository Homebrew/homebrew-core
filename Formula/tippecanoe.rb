class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.9.15.tar.gz"
  sha256 "e58cac588842a5f70d263d0e9b2eb940e32b06ab3c6560bbd650059484bab184"

  bottle do
    cellar :any
    sha256 "0db2f044811968263f674eac12d09091fd07b5cee9c17ed91322ff7fdcb29a00" => :el_capitan
    sha256 "673b9bb54a6526ca8190bf2f8bd7e946edc5bcf4296599bfa19872f2391b81fa" => :yosemite
    sha256 "0f5b315ccbe15d64da3bfd31bd86edbfd521c2dd5fb25bc2171761e8f16e4b68" => :mavericks
  end

  depends_on "protobuf-c"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.json").write <<-EOS.undent
      {"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0]}}
    EOS
    safe_system "#{bin}/tippecanoe", "-o", "test.mbtiles", "test.json"
    assert File.exist?("#{testpath}/test.mbtiles"), "tippecanoe generated no output!"
  end
end
