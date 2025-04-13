class Xpdf < Formula
  desc "PDF viewer"
  homepage "https://www.xpdfreader.com/"
  url "https://dl.xpdfreader.com/xpdf-4.05.tar.gz"
  sha256 "92707ed5acb6584fbd73f34091fda91365654ded1f31ba72f0970022cf2a5cea"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url "https://www.xpdfreader.com/download.html"
    regex(/href=.*?xpdf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:  "498ac9ead73ba9677b494feb653335acbc7ba85c41ea6001c52fa47e2bc8d364"
    sha256 cellar: :any,                 arm64_ventura: "60bdb7303f2f3c8b2018862b04f00dfbb169b08c5a91365298b1f0b6f5e2779c"
    sha256 cellar: :any,                 sonoma:        "0e6fb3a888aa52e6a8f98fd71a1e0408940624b9c32df49a976707fd3eeeeb04"
    sha256 cellar: :any,                 ventura:       "479115c082b9a0b15c166da94c0f782dda3216186dbf62874666efa2c13505cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a6a861f923c14a27ced94e1c2a8b82a520e60d130656dd6ab3769aea2770b7c"
  end

  depends_on "cmake" => :build

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "qt"

  uses_from_macos "cups"

  conflicts_with "pdf2image", "pdftohtml", "poppler",
    because: "poppler, pdftohtml, pdf2image, and xpdf install conflicting executables"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DSYSTEM_XPDFRC=#{etc}/xpdfrc", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    assert_match "Pages:", shell_output("#{bin}/pdfinfo #{testpath}/test.pdf")
  end
end
