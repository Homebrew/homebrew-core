class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.14.3.tar.gz"
  sha256 "e038dcd8538a4b1a18ac771f4ece82457691a81df030644a80830bf7b0de0f7e"

  bottle do
    cellar :any_skip_relocation
    sha256 "4216b09ec2866439d7053bea5734901b7a671647bb7a4c882958d9466affa9f9" => :sierra
    sha256 "91f95d38d626c31a373ef522f286f9db8c24c4718dc2f7dcf5bca4683a5aea0f" => :el_capitan
    sha256 "9595e7b556f1a54f85f7a613b7083c0bacab139987e88d72f15d019e8bb48275" => :yosemite
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
