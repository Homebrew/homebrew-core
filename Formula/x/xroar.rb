class Xroar < Formula
  desc "Dragon and Tandy 8-bit computer emulator"
  homepage "https://www.6809.org.uk/xroar/"
  url "https://www.6809.org.uk/xroar/dl/xroar-1.8.tar.gz"
  sha256 "9c3a557685a99d265ad414e57b258651086d403fa64996c83ca57814ad9a8b14"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5813759788a4c2da5557ab54788ab4001631187ff077b30d8f87449940234c00"
    sha256 cellar: :any,                 arm64_sonoma:  "cbaa0132f4dac92c00696bf479586ed99e355b01d1b8fbbc9ca6cdc6decc6256"
    sha256 cellar: :any,                 arm64_ventura: "a63185f75b4b99d072fb7eca4541fd2fc2709670464c8bef858ee701a1dfc47d"
    sha256 cellar: :any,                 sonoma:        "498461a27ae38d1a151a9ee8f13f95dc4748a7fe108886d2acf779974e0b4036"
    sha256 cellar: :any,                 ventura:       "7852f9080e68031d9a1c2de94e8bac5ae022710c6eb27428b938490323a0530f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e75c5064448737febd64ae4dc9f1a0d73886584a6620438230dc58d3518dd474"
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
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

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
