class Xpdf < Formula
  desc "PDF viewer"
  homepage "http://www.foolabs.com/xpdf/"
  url "https://xpdfreader-dl.s3.amazonaws.com/xpdf-4.00.tar.gz"
  mirror "https://fossies.org/linux/misc/xpdf-4.00.tar.gz"
  sha256 "ff3d92c42166e35b1ba6aec9b5f0adffb5fc05a3eb95dc49505b6e344e4216d6"

  bottle do
    sha256 "96aa36fb15857fb59208e511d02e4e7eee88b3f1b4d4bad59b6c0ec3e7aa5346" => :high_sierra
    sha256 "a1abda067ab10b0e3a79ab9a93695ca2ad5fc674fff46a686ff11df47a076119" => :sierra
    sha256 "e99ea80af29dd4dc4b3898ff4fe6dad14e904181b274be785da16103e4ec425f" => :el_capitan
    sha256 "3bd281f7bbc232ec0e353e3a54955383e13897fe563dfcadc4057e625803a6fb" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "qt"

  conflicts_with "pdf2image", "poppler",
    :because => "xpdf, pdf2image, and poppler install conflicting executables"

  def install
    # Reported 6 Feb 2018 to xpdf AT xpdfreader DOT com
    inreplace ["xpdf/CMakeLists.txt", "xpdf-qt/CMakeLists.txt"], " man/",
                                                                 " share/man/"

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    assert_match "Pages:", shell_output("#{bin}/pdfinfo #{testpath}/test.pdf")
  end
end
