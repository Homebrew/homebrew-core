class Xpdf < Formula
  desc "PDF viewer"
  homepage "https://www.xpdfreader.com/"
  url "https://dl.xpdfreader.com/xpdf-4.03.tar.gz"
  sha256 "0fe4274374c330feaadcebb7bd7700cb91203e153b26aa95952f02bf130be846"
  license "GPL-2.0"

  livecheck do
    url "https://www.xpdfreader.com/download.html"
    regex(/href=.*?xpdf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8daf2dd394f5990c3effcfe075f5e18366d6c1537b919c8bbe7aecb377b64d59"
    sha256 cellar: :any, big_sur:       "dd539162f595f665a230ea4504969da19425acf9066b4943227f6e418ba924c9"
    sha256 cellar: :any, catalina:      "6eea94e938839130aed8666e611a0a96c0457c56dd9c5ccbe108df5da732cff2"
    sha256 cellar: :any, mojave:        "1d2d40b362e1f6098884c9a8781491b4d609063ebb9c328160d8b5e4b78cf4c7"
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
