class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.24.1.tar.gz"
  sha256 "9caff598cec1863e51c1425429a4eaea113d2846f79b1d0538860388b00a3cd5"

  bottle do
    cellar :any_skip_relocation
    sha256 "17700f27297e1264597d68674b3e09da2cccfdca95c5311e262a6af956794ef4" => :sierra
    sha256 "c8ddb0af2ea45d10936aaa8fb36119ca1ae4f4b5126896d93b32bc0b69065452" => :el_capitan
    sha256 "e2e5e885c1530c45a32e77a0739c769b7f94fd43181b85a6e9c4117126ed7779" => :yosemite
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
