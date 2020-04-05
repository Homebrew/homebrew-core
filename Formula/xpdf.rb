class Xpdf < Formula
  desc "PDF viewer"
  homepage "https://www.xpdfreader.com/"
  url "https://xpdfreader-dl.s3.amazonaws.com/xpdf-4.02.tar.gz"
  sha256 "52d51dc943b9614b8da66e8662b3031a3c82dc25bfc792eac6b438aa36d549a4"

  bottle do
    cellar :any
    sha256 "ed4f85ea9e8246acb38d96b12013b66a8dfb21346a7de192fd7904c91c0a4898" => :catalina
    sha256 "703b0341d6887119375ab0ba7c3d6accfbb25cfcc5e459009c6cb09977e2005d" => :mojave
    sha256 "29808204a425d8896f855bb9f7e2e09a365a0fe577d6f522fed0a3e2f866695b" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "qt"

  conflicts_with "pdf2image", "pdftohtml", "poppler",
    :because => "poppler, pdftohtml, pdf2image, and xpdf install conflicting executables"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    assert_match "Pages:", shell_output("#{bin}/pdfinfo #{testpath}/test.pdf")
  end
end
