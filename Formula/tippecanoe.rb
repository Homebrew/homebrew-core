class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.9.12.tar.gz"
  sha256 "47231b7d1f0fd626b56cb8a7c194710321e50450623cf1a6d131badcdcb5b527"

  bottle do
    cellar :any
    sha256 "ac7aca79a335b120eb67d0f812f906aa79e37783b224d9378d5cf47fac64db12" => :el_capitan
    sha256 "cf16db45d3b1f6517dd235a35b65a34f9326baecba96acd586636492eb99e7a9" => :yosemite
    sha256 "8f8d78b56ff7c7dc1898471a5070896d9565d4e030a65c30a147904698cdb0aa" => :mavericks
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
