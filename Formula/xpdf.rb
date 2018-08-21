class Xpdf < Formula
  desc "PDF viewer"
  homepage "https://www.xpdfreader.com/"
  url "https://xpdfreader-dl.s3.amazonaws.com/xpdf-4.00.tar.gz"
  mirror "https://fossies.org/linux/misc/xpdf-4.00.tar.gz"
  sha256 "ff3d92c42166e35b1ba6aec9b5f0adffb5fc05a3eb95dc49505b6e344e4216d6"

  bottle do
    cellar :any
    sha256 "5e9b256817f4a4050cbed7d914cde590c66f989588f250983dbff80059df9670" => :mojave
    sha256 "9d27d28c52d120d30c6d2293da42a96d993171f2d68febc00c406a0e5bbe4cb9" => :high_sierra
    sha256 "e747937587f1ba1acd33b7caf1f407b1baa3951c8b31e091ea0ae6f00ccc9d79" => :sierra
    sha256 "1013c1a0224961955bed42d33a37748ac899b6f3a07f87809865974b760d59e0" => :el_capitan
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
