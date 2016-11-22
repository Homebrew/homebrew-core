class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.15.0.tar.gz"
  sha256 "080ac22a1ea4e4663e7104c601bb8e14e0ae8d0f5c6a730c915cc7f2cf267a7e"

  bottle do
    cellar :any_skip_relocation
    sha256 "08a814657c211e468bf4382f772c6039b7f0831aad2e9a05b20cc6c8f8a1c6c6" => :sierra
    sha256 "87be8ca5c514fc8e74e7fae040b058f8e2d45fdf1a3289eadb90a178db23a3c3" => :el_capitan
    sha256 "710199ea49fd9eacfd59b19dd4799a8b837e36da3eb007810a721c0a5937ec17" => :yosemite
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
