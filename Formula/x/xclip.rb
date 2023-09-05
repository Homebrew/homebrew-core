class Xclip < Formula
  desc "Access X11 clipboards from the command-line"
  homepage "https://github.com/astrand/xclip"
  url "https://github.com/astrand/xclip/archive/0.13.tar.gz"
  sha256 "ca5b8804e3c910a66423a882d79bf3c9450b875ac8528791fb60ec9de667f758"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e335771d3bb8f072b25c2cf6404f12540cfbd8692d97cd678a086a08b76f2771"
    sha256 cellar: :any,                 arm64_monterey: "ebf047556b2d594089b26ea72250eb9ea3c4a4c1f779642e08d1cfd0d131f631"
    sha256 cellar: :any,                 arm64_big_sur:  "2a9e42621fbc329856454f299e2da20b8776de9136cf1233a97ec4662ef2b5fe"
    sha256 cellar: :any,                 ventura:        "b1641761e78f6f9ca7d89ca8999e8ad04b2116ca28cee87d0f1d609b50fce4b5"
    sha256 cellar: :any,                 monterey:       "47b1812c7d1e2aa7f70f2721693b3e2ddb89761886e4432009240d4349369da0"
    sha256 cellar: :any,                 big_sur:        "4b3d034f8770dd75585b98910ce1ad1c0bbe010f91f61c814f9b655cc978e122"
    sha256 cellar: :any,                 catalina:       "2229de2d3139a5a916be1d7e6c3227ef989ff20ce4322f0881eaeb22ee34caf1"
    sha256 cellar: :any,                 mojave:         "7bacdf14b8a248a969952c6cba098e01b15d63b280b95a453164d2b0117400dc"
    sha256 cellar: :any,                 high_sierra:    "4ff44edecff889254b56f12f261127e90f20c8b0f8d10e0d7f6b41788be0b2e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "532e6b67cb0b23908b5c0d4df6157810fdb4ce8c7268e289df9cce2578230f21"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libx11"
  depends_on "libxmu"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/xclip", "-version"
  end
end
