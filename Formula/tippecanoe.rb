class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.13.0.tar.gz"
  sha256 "b03ea5ed378727ba844a66b8e8f7c3b1af9e7dbecf4fef975c381a94fb178f2e"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c107fb8fc56998cc79c12a736c6a97c77627fb99fce89ebacfeb4fd93f60d40" => :sierra
    sha256 "a265d97c9e1712a2af86d5e05ea88d3c9d6867a50a3cbf02516094d924f3dc29" => :el_capitan
    sha256 "bc81c2168ace71e21cb2e48f90b5775f9ee04c177f68768f2a7295f0781ca191" => :yosemite
    sha256 "ec2e51dd62271a430af6cee9ef6ccab58bd562c57d189c16f83e893f719c4e72" => :mavericks
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
