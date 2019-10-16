class Tiff2png < Formula
  desc "TIFF to PNG converter"
  homepage "http://www.libpng.org/pub/png/apps/tiff2png.html"
  url "https://github.com/rillian/tiff2png/archive/v0.92.tar.gz"
  sha256 "64e746560b775c3bd90f53f1b9e482f793d80ea6e7f5d90ce92645fd1cd27e4a"
  revision 1

  bottle do
    cellar :any
    sha256 "7589c830ef81bd43dd0bd3d1ba65483965701dfff8f7c4d8760951f0cf47c378" => :catalina
    sha256 "e8cf86b68e703c8c5c6fc0f6e9ffee0e2823a103cb685d4a33d21fb626a96439" => :mojave
    sha256 "e20cc758aab7de1c1e9d286e469a444fe9e384bcffe472ec6a52c06b31131ac4" => :high_sierra
    sha256 "19951f2ec63fa3c77a43fe2c2444251686ad4fcc1038fbeeb8873fcd528d8954" => :sierra
    sha256 "43f0afaca7d61a7f55489260deb233c0a35619d3101d362f80dc7a765a877599" => :el_capitan
    sha256 "bf11412cac81c328f8e8de50c182be049696d053ac900b56302685e858562811" => :yosemite
  end

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  def install
    bin.mkpath
    system "make", "INSTALL=#{prefix}", "CC=#{ENV.cc}", "install"
  end

  test do
    system "#{bin}/tiff2png", test_fixtures("test.tiff")
  end
end
