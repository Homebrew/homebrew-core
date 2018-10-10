class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.32.0.tar.gz"
  sha256 "45539e2ee8f1097450cca4aa4c1360820d46eee1a28a9fade74c64f07024382f"

  bottle do
    cellar :any_skip_relocation
    sha256 "61061dbe53a9ccc9af8a08793e5883de1c5601ed70dec0853bd9e801277c0b8f" => :mojave
    sha256 "8a56f631d5226db75d87960409529f8de135f1947dde12ea36415ad7187a166c" => :high_sierra
    sha256 "bcfa8de6e0a5514d0c371e3d401c0ab62cc2c4323b5ac146c87a0bc0ef277e6b" => :sierra
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
