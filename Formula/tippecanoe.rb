class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.22.2.tar.gz"
  sha256 "47cadb0b37d6bb58e0582d68834595beb7c53609b4f4f3b705e57ed48edad35b"

  bottle do
    cellar :any_skip_relocation
    sha256 "20f716e335cf51eea04726b05c8caf3cfe66184d56b16d44f6712184e3bd90d6" => :sierra
    sha256 "7468a2708b26bb84d6c92e83f0923a5973c56954620d4a8fb2844347014b874c" => :el_capitan
    sha256 "a8b095ca7c495f14a299a6d78a3396789ff3e21f0ca1efdd5f203cda8b934a33" => :yosemite
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
