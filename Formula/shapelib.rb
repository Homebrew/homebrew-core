class Shapelib < Formula
  desc "Library for reading and writing ArcView Shapefiles"
  homepage "http://shapelib.maptools.org/"
  url "http://download.osgeo.org/shapelib/shapelib-1.4.1.tar.gz"
  sha256 "a4c94817365761a3a4c21bb3ca1c680a6bdfd3edd61df9fdd291d3e7645923b3"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9f9e6921c851022b5ca269886a1a34e3dfcebb59eedb903cdf26b42145d03a8b" => :high_sierra
    sha256 "5ccf254ad426070dc2876c92af6674648229faa6613800983c825e9d88a34105" => :sierra
    sha256 "231ff7f01f4e050713d0525701a8478ff2de72e6f6a866f6a0b2a2f8ed3a7e29" => :el_capitan
    sha256 "ff785bd9efdab4345d8e1409934e173b2b18a35c87f522c30eef097b20c662e1" => :yosemite
    sha256 "30c19104eeb1a1d3f70ea80ed73a352e03e976610a63c5775d77a15eb7da355c" => :mavericks
    sha256 "f8d87f694df8fec823efe62702e317737c53fd5c1407f1007b7d5fae9f37974f" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "shp_file", shell_output("#{bin}/shptreedump", 1)
  end
end
