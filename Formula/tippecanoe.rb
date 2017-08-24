class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.22.2.tar.gz"
  sha256 "47cadb0b37d6bb58e0582d68834595beb7c53609b4f4f3b705e57ed48edad35b"

  bottle do
    cellar :any_skip_relocation
    sha256 "c49f60ac7a2bde878942481f4380990e917f20655efac67c0c5ade482e675dc8" => :sierra
    sha256 "a4e0aebe8ae80e5ec0a96bc9b460c0c595fe250ac1435c6b7aa30ac5ec57923e" => :el_capitan
    sha256 "629b89b3c5e7c004cbd578de7d4f4117fb50accccd62e87235127183e3865800" => :yosemite
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
