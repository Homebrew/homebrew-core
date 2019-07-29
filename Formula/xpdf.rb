class Xpdf < Formula
  desc "PDF viewer"
  homepage "https://www.xpdfreader.com/"
  url "https://xpdfreader-dl.s3.amazonaws.com/xpdf-4.01.01.tar.gz"
  sha256 "ba550c7d3e4f73b1833cfcdcd9dbe39849dd0cd459b6774c4ecdfeca993204a4"

  bottle do
    cellar :any
    sha256 "916a89503c3fff07ff5b4a6942fababff48e95ebf371a5c5a87226782baf87a2" => :mojave
    sha256 "bb8c4e6f0c4bcd2c033e6dfc38185c35a9e2c93978b6f06ea5a8a492d9791f2b" => :high_sierra
    sha256 "54afa2819e8b471452e9f8e2f04d970fdf308a3aaa63969f4cd2015464b3875d" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "qt"

  conflicts_with "pdf2image", "poppler",
    :because => "xpdf, pdf2image, and poppler install conflicting executables"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    assert_match "Pages:", shell_output("#{bin}/pdfinfo #{testpath}/test.pdf")
  end
end
