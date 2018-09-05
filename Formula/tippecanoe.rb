class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.31.0.tar.gz"
  sha256 "7ce03220ccc00b7d2455f76447919c85a3aea2f98e08530714662d1567a62741"

  bottle do
    cellar :any_skip_relocation
    sha256 "351409a0e56a218c071783131c8fef344c078561ed099462af3dfcdb903b5542" => :mojave
    sha256 "fa71d1d0f677425bbeba34e46553b5a25c5e5ad8d0898eb01b4474e9157254ec" => :high_sierra
    sha256 "0b1382c3111dcdff93f85e1a4bb7fbf44cfea2be532c8f1863f986508da7eab0" => :sierra
    sha256 "c45c28b3ffa31008ccc9398a8115d619ba7ee553c1cbf8ac8ad65811cd33c27f" => :el_capitan
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
