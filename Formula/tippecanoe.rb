class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.26.0.tar.gz"
  sha256 "3727a12e83e26679a43c55b3d60245d811e640c08e5c5b59453f710736ec93b3"

  bottle do
    cellar :any_skip_relocation
    sha256 "fbbbd8956875f7ab0e870752a16dfea8a83631b981082fb700b0e5a69ce8a3e3" => :high_sierra
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
    assert_predicate testpath/"test.mbtiles", :exist?, "tippecanoe generated no output!"
  end
end
