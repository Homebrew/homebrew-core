class Wslay < Formula
  desc "C websocket library"
  homepage "https://wslay.sourceforge.net/"
  url "https://github.com/tatsuhiro-t/wslay/releases/download/release-1.1.1/wslay-1.1.1.tar.xz"
  sha256 "166cfa9e3971f868470057ed924ae1b53f428db061b361b9a17c0508719d2cb5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "695e27c926b9cba4a774c0bead3c924fe34f11e9d151e203ee82f83c3be1ae20"
    sha256 cellar: :any,                 arm64_sonoma:   "a589896e5f7fce349934f90cee721270752c65cfb58dfca69ce9d13f6bfc52e7"
    sha256 cellar: :any,                 arm64_ventura:  "696c0681644905529efaaa30ab237023dc12c9a726af0bd7c700302308401a2a"
    sha256 cellar: :any,                 arm64_monterey: "f09d67afcce3498de58ebcb20cf0c5478ff9cd909fa3841a9545e526c31f9b34"
    sha256 cellar: :any,                 arm64_big_sur:  "3921e0d42b7388dd8229d2019d67319330b7c53e862c120612b72565a7eff37f"
    sha256 cellar: :any,                 sonoma:         "8215cb7e32c441a1f92c93ede616c06c12eb1b70817185e8d7f606737522aa71"
    sha256 cellar: :any,                 ventura:        "643367160b3009f918296e97316bb9e353cca450e0e10e79db7053ba5e563afb"
    sha256 cellar: :any,                 monterey:       "9d44bad51a861ee84b5cbdf755d7f786b4b54b49441cc5e424b1921983de0d7d"
    sha256 cellar: :any,                 big_sur:        "aa3c50a846b0e72238f22dc55ff1d158e2d2845c75997f6d508383be122d4f8f"
    sha256 cellar: :any,                 catalina:       "b0c31393b4065ddad22d079252f4310ccafee1c26d5ea56a58c2bc3bfa728b46"
    sha256 cellar: :any,                 mojave:         "4ea82d98c0fd0cfcc1e842dde6e0fbd15355d538876f24fa0c2ca6f05ed17926"
    sha256 cellar: :any,                 high_sierra:    "6aade683b7db8a32c859e54134568bdb3983d57878783d86c89e5d28c5e8db77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eee1f87dcfd142d6131fdb354f5aacdfc22991d8666e267dc5ff7fcc6df57eff"
  end

  head do
    url "https://github.com/tatsuhiro-t/wslay.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "cunit" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "check"
    system "make", "install"
  end
end
