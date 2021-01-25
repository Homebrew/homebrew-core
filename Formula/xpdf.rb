class Xpdf < Formula
  desc "PDF viewer"
  homepage "https://www.xpdfreader.com/"
  url "https://dl.xpdfreader.com/xpdf-4.02.tar.gz"
  sha256 "52d51dc943b9614b8da66e8662b3031a3c82dc25bfc792eac6b438aa36d549a4"
  license "GPL-2.0"

  livecheck do
    url "https://www.xpdfreader.com/download.html"
    regex(/href=.*?xpdf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "df33213e9a7d6d3f330d96b7402c3c1bb7afb4e3665ee71bd9835b3366ae3be2" => :big_sur
    sha256 "968cef17a786a39bf3d99a5bf9398ad58ed913bcc2588271eb23ef6d01e18c41" => :arm64_big_sur
    sha256 "f08da8bc25d97b0ca2f7b3ca6a69f57dcc32df15d74c23c01c1e4f13977320dc" => :catalina
    sha256 "c21f4b4cde0cf16509e1550d2b0a6c55b07eeb8be83614fcd62978fcb1757e29" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "qt"

  conflicts_with "pdf2image", "pdftohtml", "poppler",
    because: "poppler, pdftohtml, pdf2image, and xpdf install conflicting executables"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    assert_match "Pages:", shell_output("#{bin}/pdfinfo #{testpath}/test.pdf")
  end
end
