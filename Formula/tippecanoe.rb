class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.34.3.tar.gz"
  sha256 "7a2dd2376a93d66a82c8253a46dbfcab3eaaaaca7bf503388167b9ee251bee54"

  bottle do
    cellar :any_skip_relocation
    sha256 "2758e611a76625b097a95ce8bc54af650fc670eca381c095605156df3115be56" => :catalina
    sha256 "201ef6af440f2dcfaf9a554512e77f004fe83028f001bcb399d58d7cf68a90c8" => :mojave
    sha256 "056ce50e3b65cb5f56051869291e0e52e2d244c8282b2103a2c7718fb92d294d" => :high_sierra
    sha256 "39116d96baf12a20bd0a729491c6499805568992f3b6ad59b7800f5f3f9189a5" => :sierra
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
