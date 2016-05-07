class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.11.4.tar.gz"
  sha256 "372fdf3b2421d8d6db4fed168504a6f26fdfea6510ad117c0d105022bfff0c80"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f268c904f5cac72b3f8268129b719903647629369a19d6ed1225d5d2c79d8d7" => :el_capitan
    sha256 "3be725b74b3017979a2da426b6a228e04be7fe0ebfa2ebb983fa6d740c0ff43c" => :yosemite
    sha256 "4422d47675f8e6233d09d330cd0ab7c1aa7e73ed37bc2babac2673e707fce660" => :mavericks
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
