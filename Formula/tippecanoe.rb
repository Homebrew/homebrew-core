class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.20.0.tar.gz"
  sha256 "a2cca6c3d3addda07a13a3d6871e09716c1a051a1daa4763ab2e66f9f7839f0c"

  bottle do
    cellar :any_skip_relocation
    sha256 "58f1160f77222ce9ed7199da8f24ff9276474bd4790feb40f9e6d3f07c0eee79" => :sierra
    sha256 "457d32af7734d2154a6c8c2680287e972054653b2c639197a8c8084813ef3660" => :el_capitan
    sha256 "7e8863fb46dbd3cf2a5e9fbb0a96443643aba95ff127e245054663ec26b423a1" => :yosemite
  end

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
