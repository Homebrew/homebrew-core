class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.34.0.tar.gz"
  sha256 "85d4721de1170c9636bbfc5bcee0eef9a3f698c293863f337511c867da788b6c"

  bottle do
    cellar :any_skip_relocation
    sha256 "07040b13d9434e2f7a57240d54b7ea2affb5cb8ddca07d26613564a5d81e8c8f" => :mojave
    sha256 "bb8632b70fd155126246ab0b9b3a68a9d35fa6a0fb3bcc1efbb330d748c1685a" => :high_sierra
    sha256 "254c4f0661092f0d791b12271cab78a4c1b698e9412215e4b2e842c0b4ee306b" => :sierra
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
