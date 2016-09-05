class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.12.11.tar.gz"
  sha256 "3d2eb470578f733ed612756e5481dca6ad1e53dc3aa3855d9e7c8490c1bd5f5d"

  bottle do
    cellar :any_skip_relocation
    sha256 "6467d8e374852547f4c681c7dbcc8205d6d00c366c82d12a5224e531a162fb1c" => :el_capitan
    sha256 "8657f27749f2fd7dc9fac6a3afe5c2707adc17cf72a6995cd161f3eadc5f06e4" => :yosemite
    sha256 "e751cc89d6b433fd51a7c1633fff009f5e3403cf2f6016a6fa66e5e97acc11f0" => :mavericks
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
