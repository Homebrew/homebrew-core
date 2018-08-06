class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.30.3.tar.gz"
  sha256 "246e274dd7624c7d41addfc1c25818856c67e3b087d8aca91a5eccb35ab01322"

  bottle do
    cellar :any_skip_relocation
    sha256 "102b2cd712ca6eb1eb2f1b8f175779fd7737af1b9f7eda59403ee5813cc1b1ff" => :high_sierra
    sha256 "5c4972cc7847de404c7376ba0503156cd3c32dcfff414b3d228d713d9637bc23" => :sierra
    sha256 "4726bd860d78fce74a210d9c08c96cdbe59ab3d5f53ce37f2ed9d77bc17db948" => :el_capitan
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
