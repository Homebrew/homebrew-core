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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "a5c23ffa6e4ee580d8c3cb9f62d42ba4c70cd1c8dea4841ac8042d275fe5d743"
    sha256 cellar: :any,                 arm64_monterey: "fc5aad549b5099ce8f3d51227bfd419a4766c8b78138c8f894ac738dcb446a5f"
    sha256 cellar: :any,                 arm64_big_sur:  "015fcf888d527fab0465f6623df5dfa4166f8d0231350bd9820ec5a5e8e4c478"
    sha256 cellar: :any,                 ventura:        "b8b71e9659f72e21b0bba027a3d9bf0b6ef0b556f5e3fdd703495c2055d38bff"
    sha256 cellar: :any,                 monterey:       "f90629e090df683656a1ef289e797d24b8a4a68be0c0123ef0cfb6565512e3a9"
    sha256 cellar: :any,                 big_sur:        "2ffeda7163a03d8978f9d81203fff3a2e7ab1d868e0dfae6ef6873690dbeaa22"
    sha256 cellar: :any,                 catalina:       "1bca9dd3f72b9af25632b95ba5fa3cb9a85fa7698a7e72b61e0cdb3ec039b105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3aa57e1f93effd94b34991085a501b30f2329caff22885c2b9ebbf5e47b4277"
  end

  depends_on "cmake" => :build
  depends_on "fontconfig"
  depends_on "freetype"
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
