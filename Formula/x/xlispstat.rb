class Xlispstat < Formula
  desc "Statistical data science environment based on Lisp"
  homepage "https://homepage.stat.uiowa.edu/~luke/xls/xlsinfo/"
  url "https://homepage.cs.uiowa.edu/~luke/xls/xlispstat/current/xlispstat-3-52-23.tar.gz"
  version "3.52.23"
  sha256 "9bf165eb3f92384373dab34f9a56ec8455ff9e2bf7dff6485e807767e6ce6cf4"
  license "HPND-sell-variant"
  revision 1

  livecheck do
    url "https://homepage.cs.uiowa.edu/~luke/xls/xlispstat/current/"
    regex(/href=.*?xlispstat[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match[0].tr("-", ".") }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "cf23b57eb4e3246a8456d4243f04d704a3a2128d763021876a9b5777010888e5"
    sha256 cellar: :any,                 arm64_sequoia:  "455b2e247dd57ef595e2576a56d707ec8ced866ec15d808fc2cf93089aff07b6"
    sha256 cellar: :any,                 arm64_sonoma:   "10e7f44257e5722b9d044d17e1797df027796f291010ea9ccb5a4c3999424208"
    sha256 cellar: :any,                 arm64_ventura:  "3b11acb44e728fb2b1707b8700d5b0be9a68ff522884827fe824d44d6333ca33"
    sha256 cellar: :any,                 arm64_monterey: "e11e76582f1aa365ed04b44c6caac0a786b63f12b612399e27ed909803c1bdcf"
    sha256 cellar: :any,                 arm64_big_sur:  "1c7230181f7447fb264b14c84d8a6a2e3396faec78af73174ed6543f19536a8a"
    sha256 cellar: :any,                 sonoma:         "fcfee4172bf01f3bf39432e7c7e12b8f73e67d5d36de47e74dbff16d5ece3012"
    sha256 cellar: :any,                 ventura:        "03fc5d039c560d5d3cab884da3911ca4752b5686ca5e9399e8a3417f44da7fdf"
    sha256 cellar: :any,                 monterey:       "9d418608c03816945f00a2ccbf93def9a54e6f8b9c00c93b7835a287cf7c2305"
    sha256 cellar: :any,                 big_sur:        "30bde68dbe2eada5b7646e5ef4b6fc0f804be39f37ae75244955b3befe803036"
    sha256 cellar: :any,                 catalina:       "d2e8f57e8dc13c6b1aaa38af29d291b5974b642626599cf478f3997e2981643a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f9ce0920180e4cab96fc3e9b55a0fe5e95bee6b4de40a7ca7121f2068daaea2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45f4149aaf05fa78c789492de2867074891abc4816a5b6abbf04d06433c135d6"
  end

  depends_on "libx11"

  def install
    # Fix compile with newer Clang
    ENV.append "CC", "-Wno-implicit-int -Wno-int-conversion" if DevelopmentTools.clang_build_version >= 1403

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    ENV.deparallelize # Or make fails bytecompiling lisp code
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "> 50.5\n> ", pipe_output("#{bin}/xlispstat | tail -2", "(median (iseq 1 100))")
  end
end
