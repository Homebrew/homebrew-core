class Sxiv < Formula
  desc "Simple X Image Viewer"
  homepage "https://github.com/muennich/sxiv"
  url "https://github.com/muennich/sxiv/archive/v26.tar.gz"
  sha256 "a382ad57734243818e828ba161fc0357b48d8f3a7f8c29cac183492b46b58949"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/muennich/sxiv.git"

  bottle do
    cellar :any
    sha256 "0fbf88dbb8f6744d36254023302ea2c88521bd4b8b8172eff00c7dfe2bfd4495" => :big_sur
    sha256 "11aff8aaab1a32a0694672b802f9399d5002f1871329054671273a2d919b4d5d" => :arm64_big_sur
    sha256 "caafa51424cd97f030b9156aeba0ba64f6ab5821197453136a240c7ca38869d9" => :catalina
    sha256 "14b4f8a7137ea1ff12dde1d0a8cda063227e48d77ba75d93ecbde6193584d2cf" => :mojave
    sha256 "b8f60f5b9bb6987f0042ac485eb0d4c5c5c3cdc4ea4c32fc13def537e51d39dc" => :high_sierra
  end

  depends_on "giflib"
  depends_on "imlib2"
  depends_on "libexif"
  depends_on "libx11"
  depends_on "libxft"

  def install
    system "make", "PREFIX=#{prefix}", "AUTORELOAD=nop",
                   "CPPFLAGS=-I#{Formula["freetype2"].opt_include}/freetype2",
                   "LDLIBS=-lpthread", "install"
  end

  test do
    assert_match "Error opening X display", shell_output("DISPLAY= #{bin}/sxiv #{test_fixtures("test.png")} 2>&1", 1)
  end
end
