class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.34.0.tar.gz"
  sha256 "85d4721de1170c9636bbfc5bcee0eef9a3f698c293863f337511c867da788b6c"

  bottle do
    cellar :any_skip_relocation
    sha256 "fdf39bef8a5ee47bc74acead64a997eda7a2389f1f2219ae614e1cfe4347f5a7" => :mojave
    sha256 "b74697e62c2a75173180305b111b6ea8fc39bd63e129c02e23f512dff4890fc8" => :high_sierra
    sha256 "3e4ed79fac548f7868e163a050023498c91450a9e247f630dd779d9e561a9734" => :sierra
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
