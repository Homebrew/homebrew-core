class Xpdf < Formula
  desc "PDF viewer"
  homepage "https://www.xpdfreader.com/"
  url "https://dl.xpdfreader.com/xpdf-4.04.tar.gz"
  sha256 "63ce23fcbf76048f524c40be479ac3840d7a2cbadb6d1e0646ea77926656bade"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url "https://www.xpdfreader.com/download.html"
    regex(/href=.*?xpdf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "609baf11a3fcb6329bae23a823b83211a6f48d9cab4492e5cfa659740ffbaff6"
    sha256 cellar: :any,                 arm64_big_sur:  "65d202da357fd658a3e739a907d32d8a033f5887387cf4962486b159cc0f986c"
    sha256 cellar: :any,                 monterey:       "afa2e4bc4335c584c62893c18bfbc8fd4050f36638ec15c0bfaa576d49c4449b"
    sha256 cellar: :any,                 big_sur:        "69111a8ce5871e43fa7d9a0beaac826001afca06e5cfbaed45a621575be73508"
    sha256 cellar: :any,                 catalina:       "2078a6e70ae0e9d321b3f49610f6a2cc904eb30249a859e003fcbc97be01ef98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e5c6c069c929a71c97efd2afed4adde3a4657bdc37048de69d09445cdceb3b0"
  end

  depends_on "cmake" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "qt@5"

  on_linux do
    depends_on "gcc"
  end

  conflicts_with "pdf2image", "pdftohtml", "poppler",
    because: "poppler, pdftohtml, pdf2image, and xpdf install conflicting executables"

  fails_with gcc: "5"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    assert_match "Pages:", shell_output("#{bin}/pdfinfo #{testpath}/test.pdf")
  end
end
