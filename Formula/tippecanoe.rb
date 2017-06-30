class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.19.2.tar.gz"
  sha256 "2c744faf8fb068a1d155f5346e1833b1c45bbcfc9c52cc9d6fae7fbcce735e36"

  bottle do
    cellar :any_skip_relocation
    sha256 "6251e03dad8790d828eb3bf93349a5c8253b770bdb8639d23529d5c3b2d4ecee" => :sierra
    sha256 "0287651272c6cdc1845bcf55dd2efe0c5fbac20b326fdb19f985b540e5f53d14" => :el_capitan
    sha256 "3f02752b0cd9c6dea166bc815e53493cc494641035f3615d7b94ad5e0687a638" => :yosemite
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
