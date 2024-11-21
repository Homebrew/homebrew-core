class Xroar < Formula
  desc "Dragon and Tandy 8-bit computer emulator"
  homepage "https://www.6809.org.uk/xroar/"
  url "https://www.6809.org.uk/xroar/dl/xroar-1.7.tar.gz"
  sha256 "6e35a40a44449be95c82aff96e74438132ac424184295955729a5b551e80f9ec"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8376dd921f441a7d43f4a10e4d0e9fc210070aa7a78d3038ae813e059ae50fb4"
    sha256 cellar: :any,                 arm64_sonoma:  "c6530924e507efa90e32d05be08d9d1a62e572819367dc92707933650d020e7c"
    sha256 cellar: :any,                 arm64_ventura: "30fee0f66459425d3ef2f05753972d84f4d91dfa6b118d6be9652df557e20f47"
    sha256 cellar: :any,                 sonoma:        "9f29090adaf0bce38434be682ef4fb4929d9c2a933a3b4d30879019a06cef774"
    sha256 cellar: :any,                 ventura:       "a570c72efb925b959c11ff3574ea37ec35e0ab40554cf391262df34303317098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e112584204301dba8761f5b58b9c0b67e7245c9e785e4aba2e78cdc16277008"
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
    depends_on "mesa"
    depends_on "pulseaudio"
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
