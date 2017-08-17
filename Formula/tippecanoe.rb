class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.22.1.tar.gz"
  sha256 "1452a932c02dcd8a25d96fae6ac3cc6b813c143c9923d555b89280722b7ebe43"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b008ea3c089fea4a0f4bece218539736d0727bc9c8805ec44608b8b30cd68d4" => :sierra
    sha256 "d06587ca875c721d66712f411abe28c99e8ebe98ef4081e42de3735e08ffbe25" => :el_capitan
    sha256 "e86b21247526447b9d724142b3b99b3efe56dcc28ccc0b70aad6f7d59031bd99" => :yosemite
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
