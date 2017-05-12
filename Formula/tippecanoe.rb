class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.18.0.tar.gz"
  sha256 "b114f1c000519e653db3e0b5a16fa72051d4163e0baba5046a1ab6247a151479"

  bottle do
    cellar :any_skip_relocation
    sha256 "fce949e6624b7d7b5548e424a4be5560fd6a4e94529a1ab5f06b3248f21f1068" => :sierra
    sha256 "0854c9d4f1818148a411879ae0e3018eb7ef757ce8f8baf4f6aad917c703ae53" => :el_capitan
    sha256 "075ff7445303765fca01130699369dde0ad0b4aa201f15eff32b5c67297650e8" => :yosemite
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
