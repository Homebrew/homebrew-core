class Xdpyinfo < Formula
  desc "X.Org: Utility for displaying information about an X server"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/app/xdpyinfo-1.3.3.tar.xz"
  sha256 "356d5fd62f3e98ee36d6becf1b32d4ab6112d618339fb4b592ccffbd9e0fc206"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e16a49d773d8c80163a2965507811ce520f17892f097d5d8f2aacd25f49b4a49"
    sha256 cellar: :any,                 arm64_monterey: "a3bf79d6694303ce41fb825dfdf0c3346c192055520a269172ca807fbd0ddd11"
    sha256 cellar: :any,                 arm64_big_sur:  "9ab87e3026a19b8a1769586cb2cfdb2d82fe5b84b66b3ac25b11db5529c6d924"
    sha256 cellar: :any,                 ventura:        "a304d4431fff5b506c0721ea6b2cc4717349eee1b93abafd95f80bc614451530"
    sha256 cellar: :any,                 monterey:       "4a7bb6ee4b0168a8b8e6d5b638df938c1e3008f00451f415bde65fdb5acecfbf"
    sha256 cellar: :any,                 big_sur:        "2139a548a2a741429b1544be0382a71d66c5bce943f51e699fdab20d72fe06a7"
    sha256 cellar: :any,                 catalina:       "a980564366bb676ec30ae2948c15f0976760e0a63f266d84349306346c49b3ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47fa8e46b0bf43f4063d5de687991fa34846d3f81f3bb505867350925a872dd9"
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"
  depends_on "libxtst"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    # xdpyinfo:  unable to open display "".
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match("xdpyinfo #{version}", shell_output("DISPLAY= xdpyinfo -version 2>&1"))
  end
end
