class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.12.0.tar.gz"
  sha256 "4254acd5d4d1853cda30430ab7c215fbf90bedf91073155fa23630aed5e8caff"

  bottle do
    cellar :any_skip_relocation
    sha256 "613e77249959605cbc6dfae1afde8f3091e67112c999f8800d541f188782b350" => :el_capitan
    sha256 "ed3b28109cf6761f8b46868e1cffb78b2089e122826acd924d65f6b856b83c00" => :yosemite
    sha256 "9883ed5d9e9e9ff6a1cadafed5ec75e1cc7fc0c41e39bc6a8d3341131c267a14" => :mavericks
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
