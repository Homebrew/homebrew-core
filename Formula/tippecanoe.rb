class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.19.2.tar.gz"
  sha256 "2c744faf8fb068a1d155f5346e1833b1c45bbcfc9c52cc9d6fae7fbcce735e36"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9954fbbe1492c425c967fe8f0d5f37ee70ee71cb18d058b5dce0bf67b1b109e" => :sierra
    sha256 "a94dcf401d2a51413163641148806e56f060527d173e6188a15498a7fa88eea0" => :el_capitan
    sha256 "6a0a1eb669038a1171fd4e762d2c0d2479d9c5dbc06c68e5299a2317de752ede" => :yosemite
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
