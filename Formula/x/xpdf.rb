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
    sha256 cellar: :any,                 arm64_sonoma:   "fa1671618f3f9efa35959abd97e504bf6e08dd435e2bbf000cf195dcfee6d01c"
    sha256 cellar: :any,                 arm64_ventura:  "e5774761d4a6a79893e0d2af59ddbf9ac178662bcc31f4144f0eab744269f53b"
    sha256 cellar: :any,                 arm64_monterey: "61ac5eba04cc8ab73c4f588979d0e02a76b0b5b5475a4e9e03486e980018bdf9"
    sha256 cellar: :any,                 sonoma:         "7da20a5e9e850794d98b08ef544a69d4f856683533345bb9dfe3b1fcc421b765"
    sha256 cellar: :any,                 ventura:        "b9003b9879cfeb6e6979859a121b59dd899e2b490a87c8e01aa4fa8ce0defcc1"
    sha256 cellar: :any,                 monterey:       "e82e5ccffe6c04337eea25d975a84777747c190d1c1b458b9cc2cf1bb0c6f443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3951386ab869791ccd7da42c52c7298137abd308e5ba10a3ab7c4426b330e552"
  end

  depends_on "cmake" => :build

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "qt@5"

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
