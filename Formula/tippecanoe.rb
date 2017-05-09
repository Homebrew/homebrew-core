class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.17.7.tar.gz"
  sha256 "5d126a3c41f9159c84453b30b63ae1667d8531dbd1d567dd60413d495b099fc4"

  bottle do
    cellar :any_skip_relocation
    sha256 "267a5318ae465faccf4b4b22ec062896a9f3bb7d497b885bcfbd4862deebc870" => :sierra
    sha256 "455f38149ea5bb10ca815ad382670753228f24474e39d6fe887c5ef10a9ac17d" => :el_capitan
    sha256 "a7a332b5de6dc9928fd909224eb934c572d6da69a4d60f5de5746c93fa5e0762" => :yosemite
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
