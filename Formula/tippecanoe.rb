class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.30.3.tar.gz"
  sha256 "246e274dd7624c7d41addfc1c25818856c67e3b087d8aca91a5eccb35ab01322"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f306cef5f3f8d1e66300679d1ebf025fa1c92b638062b454d992a438cd5aa29" => :high_sierra
    sha256 "6ab2c2bde3417ce00ae6a30cb798e28fe38b6c852a663d0f0427884d707e08cb" => :sierra
    sha256 "d0d1c2a925fc34e11b6b00dab810ab812670e97d9964ed2410ab91185c3710b6" => :el_capitan
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
