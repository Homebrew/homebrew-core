class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.14.4.tar.gz"
  sha256 "8182adc59709b182f196a4258cbe9024eb4b938af70567075cd62082762a7001"

  bottle do
    cellar :any_skip_relocation
    sha256 "a38904c410c5c5ca4ac40f8ab9a45d2eb2ef75f189324dd2debc08d07d25d98d" => :sierra
    sha256 "480c581f08212a7305a3295c1152cf088de46ea9bebebfdfee0533d82053fe06" => :el_capitan
    sha256 "60b4a22639cac708c29b7ff3beb71c7b502f9adc32e2718481ba912e245efab7" => :yosemite
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
