class Xpdf < Formula
  desc "PDF tools and viewer"
  homepage "https://www.xpdfreader.com/"
  url "https://www.xpdfreader.com/dl/xpdf-4.00.tar.gz"
  sha256 "ff3d92c42166e35b1ba6aec9b5f0adffb5fc05a3eb95dc49505b6e344e4216d6"

  bottle do
    sha256 "a1abda067ab10b0e3a79ab9a93695ca2ad5fc674fff46a686ff11df47a076119" => :sierra
    sha256 "e99ea80af29dd4dc4b3898ff4fe6dad14e904181b274be785da16103e4ec425f" => :el_capitan
    sha256 "3bd281f7bbc232ec0e353e3a54955383e13897fe563dfcadc4057e625803a6fb" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "qt" => :optional

  conflicts_with "pdf2image", "poppler",
    :because => "xpdf, pdf2image, and poppler install conflicting executables"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    assert_match "Pages:", shell_output("#{bin}/pdfinfo #{testpath}/test.pdf")
  end
end
