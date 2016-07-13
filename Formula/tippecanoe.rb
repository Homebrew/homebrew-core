class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.12.5.tar.gz"
  sha256 "119ad45496bea75b7985c6b2b5ee95ddfa965ae099990ed8841973a95ffdfbae"

  bottle do
    cellar :any_skip_relocation
    sha256 "617b60902032588a7080035aefe3ecbcf798acf10fac9dfa4cf6cc2b5c950cea" => :el_capitan
    sha256 "f104a9bb65dc9df4544dde851e0c57749edb9c9e1d1948937a8e5951f94b12d1" => :yosemite
    sha256 "18908f8b511cf3b4a0c52c3a06306e54dd7a9fa9356d3b4a7aa5eae043d08672" => :mavericks
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
