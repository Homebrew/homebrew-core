class Xshogi < Formula
  desc "X11 interface for GNU Shogi"
  homepage "https://www.gnu.org/software/gnushogi/"
  url "https://ftp.gnu.org/gnu/gnushogi/xshogi-1.4.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnushogi/xshogi-1.4.2.tar.gz"
  sha256 "2e2f1145e3317143615a764411178f538bd54945646b14fc2264aaeaa105dab6"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4f3219605fa0e580f072a4d33db039140e003f9490e92cfc9992e1f240d80bb0"
    sha256 cellar: :any,                 arm64_big_sur:  "fc650945fdedff5236f9cd3ca7e04732e67e3c46a7c3ca1e592be1dfe16c69c3"
    sha256 cellar: :any,                 monterey:       "eb6d154b030845b91a1df8c3a241da4b9268397869af45be410cfd883b9271d5"
    sha256 cellar: :any,                 big_sur:        "998ba1de10cc68bfa3c111576e0ea9bc09cab9a8cc308590e3d0914482b62178"
    sha256 cellar: :any,                 catalina:       "32cdfaceb15bbd7ebc4e2a8d26ca31c0008ce2ed1ef90f6f5309d7157ab722f6"
    sha256 cellar: :any,                 mojave:         "378503de599c2f121c06902aa2235a059b9e47963a80b1f29f7eb4b37b950479"
    sha256 cellar: :any,                 high_sierra:    "a52ad3a749214e18e02807f479b428f909d87c556cbeeb015dbf1b7b27d1fcb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c3a0fec7245f9e320b4565226493ed79e11e2e5a58a2ae9cbd569dc63fa5ffc"
  end

  depends_on "gnu-shogi"
  depends_on "libx11"
  depends_on "libxaw"
  depends_on "libxext"
  depends_on "libxmu"
  depends_on "libxt"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make", "install"
  end
end
