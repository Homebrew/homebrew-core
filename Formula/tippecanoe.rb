class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.12.11.tar.gz"
  sha256 "3d2eb470578f733ed612756e5481dca6ad1e53dc3aa3855d9e7c8490c1bd5f5d"

  bottle do
    cellar :any_skip_relocation
    sha256 "654efe370c2334db2bffb2f43756cb8218ad81d2491a36b6af42dcc3b93bb823" => :el_capitan
    sha256 "38bc3f11c600031b2ee6554395d297bbf8a02b96811ffb09bb8c5af6a3710986" => :yosemite
    sha256 "b7fe38bf057b8c1cd5f083f6589f6f3ebec7a7f4ca8a338c4840f34b42ccd048" => :mavericks
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
