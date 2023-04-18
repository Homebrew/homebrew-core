class Sng < Formula
  desc "Enable lossless editing of PNGs via a textual representation"
  homepage "https://sng.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sng/sng-1.1.0.tar.gz"
  sha256 "119c55870c1d1bdc65f7de9dbc62929ccb0c301c2fb79f77df63f5d477f34619"
  license "Zlib"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "6e6f0d6e03e0b52db9b6e4a802df9d6341840223af2b1b7e295bc743adf5253d"
    sha256 arm64_monterey: "ca4f0ca6bb0e526a3726748f0b324d1d1aae3f017c8e74de1680ef932b511d15"
    sha256 arm64_big_sur:  "441c39690c079231af81a27fce72a0f0ea7cf982c9e48e320160ccc7304486a0"
    sha256 ventura:        "379346351f679ec6fce2a3546bcccd48cbc31f885fb0e0be6405e019b3f7fe2d"
    sha256 monterey:       "6f1323983fee9df6d97091c41c7f6df1b5ced3980a0a8bb72e1553db6d3a2656"
    sha256 big_sur:        "f0e4ce732890622d796d3ab7d5c2d078f9ad327e5d64bdf9d7625b15d7a38281"
    sha256 catalina:       "070137e810c2ea02cdb3727ef7fc0da31065762ed6fee972a33d8690fc43e051"
    sha256 mojave:         "de4c08894b82e37ff3fc07fd0ade38ede24bcf241757f0b6392ab2f4a5f87d67"
    sha256 x86_64_linux:   "be14ddf01908c6812e41c87ca5210adde91fe356e46704a380259b587b9741a3"
  end

  depends_on "libpng"
  depends_on "xorgrgb"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-rgbtxt=#{Formula["xorgrgb"].share}/X11/rgb.txt"
    system "make", "install"
  end

  test do
    cp test_fixtures("test.png"), "test.png"
    system bin/"sng", "test.png"
    assert_includes File.read("test.sng"), "width: 8; height: 8; bitdepth: 8;"
  end
end
