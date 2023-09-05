class Sxiv < Formula
  desc "Simple X Image Viewer"
  homepage "https://github.com/muennich/sxiv"
  url "https://github.com/muennich/sxiv/archive/v26.tar.gz"
  sha256 "a382ad57734243818e828ba161fc0357b48d8f3a7f8c29cac183492b46b58949"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/muennich/sxiv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d9f3497a6f6c073c49e1bc04859432bee31f8702a772dc77a71ec7f7b5f5631f"
    sha256 cellar: :any,                 arm64_big_sur:  "11aff8aaab1a32a0694672b802f9399d5002f1871329054671273a2d919b4d5d"
    sha256 cellar: :any,                 monterey:       "bad469caf7406199197e00f9128659888aac1ce58b5c01415958eaa139bfb75e"
    sha256 cellar: :any,                 big_sur:        "0fbf88dbb8f6744d36254023302ea2c88521bd4b8b8172eff00c7dfe2bfd4495"
    sha256 cellar: :any,                 catalina:       "caafa51424cd97f030b9156aeba0ba64f6ab5821197453136a240c7ca38869d9"
    sha256 cellar: :any,                 mojave:         "14b4f8a7137ea1ff12dde1d0a8cda063227e48d77ba75d93ecbde6193584d2cf"
    sha256 cellar: :any,                 high_sierra:    "b8f60f5b9bb6987f0042ac485eb0d4c5c5c3cdc4ea4c32fc13def537e51d39dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83e501a472f4a821202cfc62a9076c35655d340e127b6465384ceb9d535ddf86"
  end

  disable! date: "2022-10-19", because: :repo_archived

  depends_on "giflib"
  depends_on "imlib2"
  depends_on "libexif"
  depends_on "libx11"
  depends_on "libxft"

  def install
    system "make", "PREFIX=#{prefix}", "AUTORELOAD=nop",
                   "CPPFLAGS=-I#{Formula["freetype2"].opt_include}/freetype2",
                   "LDLIBS=-lpthread", "install"
  end

  test do
    assert_match "Error opening X display", shell_output("DISPLAY= #{bin}/sxiv #{test_fixtures("test.png")} 2>&1", 1)
  end
end
