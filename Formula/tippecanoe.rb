class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.21.0.tar.gz"
  sha256 "2aa789addbe134940a30f9dbed09922e3e9470198b5fe3d73c6fb9c74797799b"

  bottle do
    cellar :any_skip_relocation
    sha256 "28d94697f51730f4ca9b3b8d40d16a480d3071060fd8fb5f021879ae5c520dcd" => :sierra
    sha256 "a864687b9ec9aeb0d09b63e7dade3fea1cf103e4150e853c5c3b41c7d6f1ee23" => :el_capitan
    sha256 "5c8565c0d999e59c9f2cae67688ae4f62d5e8c9bf5f3a7f47d5ea813c5b6eae8" => :yosemite
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
