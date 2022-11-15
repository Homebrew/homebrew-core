class Qrencode < Formula
  desc "QR Code generation"
  homepage "https://fukuchi.org/works/qrencode/index.html.en"
  license "LGPL-2.1-or-later"

  stable do
    url "https://fukuchi.org/works/qrencode/qrencode-4.1.1.tar.gz"
    sha256 "da448ed4f52aba6bcb0cd48cac0dd51b8692bccc4cd127431402fca6f8171e8e"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url "https://fukuchi.org/works/qrencode/"
    regex(/href=.*?qrencode[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c3065a87ad978bc0c2b3ff5a60371ad8f0d6f1f29d0584ac070e6cd998469561"
    sha256 cellar: :any,                 arm64_monterey: "6fa3a670e9708cf84470f82fd966e5610d0ad9d8c96c1f5987645b4db3fa65cb"
    sha256 cellar: :any,                 arm64_big_sur:  "aba117089d1c60fd2fa1d36fbfa06a0929b23d5bb6a7417d6f2dafb5dcc32c5b"
    sha256 cellar: :any,                 ventura:        "882d866b0ce145f3eef1b497ad8ffeae5d415984b28bcf77dd684d6dab789bb7"
    sha256 cellar: :any,                 monterey:       "ebc1b405866a1c2736d1fc49d268e35d08faf6a676f3151b160e1414b0edadc2"
    sha256 cellar: :any,                 big_sur:        "1b3d2022412f9d5486550fb68250aee25bb358a04e2cccc7bb85c7d65b1885b0"
    sha256 cellar: :any,                 catalina:       "326d2f182c7c8d9188be7adda5bd0ecb5922269f60f72ac265e404fa17fb310f"
    sha256 cellar: :any,                 mojave:         "a8ec712f32c4d8b09d4c098c37264ea41f0f382525c5b67e657248fdd9f1f53d"
    sha256 cellar: :any,                 high_sierra:    "a6d123b7f88941fe9959970d8b6ccfbc426c2ec405cfc731bc259f2b0f536171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97aa13d3b6314c8a5d03edffa65c43f2f63b894a91a350de52a45367fe8f862f"
  end

  head do
    url "https://github.com/fukuchi/libqrencode.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/qrencode", "123456789", "-o", "test.png"
  end
end
