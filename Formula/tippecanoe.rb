class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.12.0.tar.gz"
  sha256 "4254acd5d4d1853cda30430ab7c215fbf90bedf91073155fa23630aed5e8caff"

  bottle do
    cellar :any_skip_relocation
    sha256 "336750bfebe2d376e586862ed22b1846f9702d3fdefd89adf9e7aaf74fca71b1" => :el_capitan
    sha256 "6c55515c5ce72f754b5fcea2dad19eba2c81653be20af6f3790db03fb2129a6b" => :yosemite
    sha256 "8b7574213620f7e846fdd54cd703f658f4a92666e254b3be49cc58206490ce55" => :mavericks
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
