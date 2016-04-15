class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.9.12.tar.gz"
  sha256 "47231b7d1f0fd626b56cb8a7c194710321e50450623cf1a6d131badcdcb5b527"

  bottle do
    cellar :any
    sha256 "8cb5f5fd870c8455e3d17e190afd3ee3fc66cb294924488c339359e7c316dce9" => :el_capitan
    sha256 "d3a51c20defb16d28dd577ac6d0506e545d801f633a1af3a8d50da6b07c17958" => :yosemite
    sha256 "845a9f85bd7993530403084545fa673352fb91bad4f7c888c8b9b5a112c063ff" => :mavericks
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
