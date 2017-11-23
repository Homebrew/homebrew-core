class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.27.1.tar.gz"
  sha256 "b967af98bd02e4c6a26f38b48a095e3445d98e50d6074cce2d2f573c89b58d4f"

  bottle do
    cellar :any_skip_relocation
    sha256 "218df50fc296adf5751958723bcdbe906e66be14c8a0898e8ef4c92e831ff632" => :high_sierra
    sha256 "e1435c5df13e8b0c885304c540878835e86caf9b235544cb28ab5622d935ed88" => :sierra
    sha256 "f6576005861dcd7f2ecf8d7c093e076a05ddbc2d59f5d0cfbf6408f14434a0a6" => :el_capitan
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
