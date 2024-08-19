class Xroar < Formula
  desc "Dragon and Tandy 8-bit computer emulator"
  homepage "https://www.6809.org.uk/xroar/"
  url "https://www.6809.org.uk/xroar/dl/xroar-1.5.5.tar.gz"
  sha256 "a39b319aa5d46f455e8973cf7f3b6da67f24231dc1c91fdcb3c09e7a689d3c8b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "56f21d222837c9be1be83971a78f6a64615f14cc2098c9a30913ac10041658eb"
    sha256 cellar: :any,                 arm64_ventura:  "9aa0fdc08b91d8e4588a7790084270806d4bf480edd54ce649c28b61770f9e34"
    sha256 cellar: :any,                 arm64_monterey: "01124a5e4d2d6dc05a18a81a3f88698694fb1146755260de06726df32f83886b"
    sha256 cellar: :any,                 sonoma:         "a9a0ae6b2ec3fa132f50b3c1847de52ba701438a3d43e303a9797c56341068ed"
    sha256 cellar: :any,                 ventura:        "5021d6571619e0c96ad73b77577851d67c6c5ddd209f155628b9df599a42c0e4"
    sha256 cellar: :any,                 monterey:       "075fdbc6564f72c1cec88039c6a095dbf01e4cd0f00cc5be5e83ffb309d54446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22ca19d485ff3f07848f7d0ddb148d48965328e1fa79167723883c2d108f8143"
  end

  head do
    url "https://www.6809.org.uk/git/xroar.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "texinfo" => :build
  end

  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules", "--without-x", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output(bin/"xroar -config-print")

    assert_match(/machine dragon32/, output)
    assert_match(/machine dragon64/, output)
    assert_match(/machine tano/, output)
    assert_match(/machine dragon200e/, output)
    assert_match(/machine coco/, output)
    assert_match(/machine cocous/, output)
    assert_match(/machine coco2b/, output)
    assert_match(/machine coco2bus/, output)
    assert_match(/machine coco3/, output)
    assert_match(/machine coco3p/, output)
    assert_match(/machine mx1600/, output)
    assert_match(/machine mc10/, output)
    assert_match(/machine alice/, output)
  end
end
