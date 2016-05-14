class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.11.4.tar.gz"
  sha256 "372fdf3b2421d8d6db4fed168504a6f26fdfea6510ad117c0d105022bfff0c80"

  bottle do
    cellar :any_skip_relocation
    sha256 "213d2e989ab50309f1f9049c10d88910c3df8ea5c01146a608414a64862ff0a5" => :el_capitan
    sha256 "89a1f6c00f883da3deb103abf9f9a33299fc0584e12e1e49689543e6d9a13a07" => :yosemite
    sha256 "8b9127308d3e6b4474372353976125259de1a3a6530a282bc8962ae083f2f042" => :mavericks
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
