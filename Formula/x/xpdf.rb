class Xpdf < Formula
  desc "PDF viewer"
  homepage "https://www.xpdfreader.com/"
  url "https://dl.xpdfreader.com/xpdf-4.06.tar.gz"
  sha256 "1c38f527c46caee0f712386d42a885b96a31ed9ce11904e872559859894d137e"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url "https://www.xpdfreader.com/download.html"
    regex(/href=.*?xpdf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4dd0eb582bdc7b4379aa8e77644af37c4e8e096a8696d4a0fbdc23ccc4cba193"
    sha256 cellar: :any,                 arm64_sequoia: "60cc7f994a18afe6a5ae628ab060f6c6c5413d83f01df8b06c1a25bc63c91cb0"
    sha256 cellar: :any,                 arm64_sonoma:  "6cfb145e1263312e350bd59bb67cbcc92f5e30fce85b66868ca2cc2e052c008d"
    sha256 cellar: :any,                 sonoma:        "6189984381ed79a12c107361576d6d2dc387e9c7f96a95b29214b490344559aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54e5a8dfab3cc64ed798baed055e7ebc46ce23990c3af9f10cc3df4a43732456"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19ebbcae1282fab3ebb7f695353528f51bd149bdf426d36d889b6c88fc85551a"
  end

  depends_on "cmake" => :build

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "qtbase"
  depends_on "qtsvg" => :no_linkage # for svg icons

  uses_from_macos "cups"

  conflicts_with "pdf2image", "pdftohtml", "poppler",
    because: "poppler, pdftohtml, pdf2image, and xpdf install conflicting executables"

  def install
    args = %W[-DSYSTEM_XPDFRC=#{etc}/xpdfrc]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    assert_match "Pages:", shell_output("#{bin}/pdfinfo #{testpath}/test.pdf")
  end
end
