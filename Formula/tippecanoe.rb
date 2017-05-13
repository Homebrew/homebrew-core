class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.18.1.tar.gz"
  sha256 "30561d908333d455d285c70cf721c1d18309f6a02e28aef03c1cc660ae849288"

  bottle do
    cellar :any_skip_relocation
    sha256 "d5d3d62bf8cdea0842804be2801201fc1da0236d45da70a44bbf13b5e85bb277" => :sierra
    sha256 "4596995ef959dea6fd795521974475076f305ea2487e51b4a891878b7997f07f" => :el_capitan
    sha256 "cdff8b6e53d7e5e7691fb012a7f23d4cb7c5cf3f878f99dcecdd915a70dd7104" => :yosemite
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
