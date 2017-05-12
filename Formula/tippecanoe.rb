class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.18.1.tar.gz"
  sha256 "30561d908333d455d285c70cf721c1d18309f6a02e28aef03c1cc660ae849288"

  bottle do
    cellar :any_skip_relocation
    sha256 "b557be1386ac14e4ecb1b456627a8033a95c3b49de3500d5f7632869de9c9441" => :sierra
    sha256 "691d748416479e3c7cad80bcd70da6c1e2b6267c96288097d9684b493441b1d7" => :el_capitan
    sha256 "d086709345717e0ec7248939c52b195d41138bb692c288578798bd549abfd55c" => :yosemite
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
