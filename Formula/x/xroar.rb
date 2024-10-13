class Xroar < Formula
  desc "Dragon and Tandy 8-bit computer emulator"
  homepage "https://www.6809.org.uk/xroar/"
  url "https://www.6809.org.uk/xroar/dl/xroar-1.6.5.tar.gz"
  sha256 "fd2e5812578924d4b0cbc5c87375caae8a56aebea0b78f63a2399a216778b4f8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "32c9802cca6fccfb27e357d554516b0e54fe5ec6401e762b3edf7e3f75595ca9"
    sha256 cellar: :any,                 arm64_sonoma:  "9fb94d2563d8953bba54a143b05722b3d1a6d042e5d7cf03a07b83b033ba3a1f"
    sha256 cellar: :any,                 arm64_ventura: "21a8c3a2415ee9853d89da0f9edbc9f3af4d239e0ec7e9b8ff54ab160e1bb8d2"
    sha256 cellar: :any,                 sonoma:        "aca75c44f5052a3fb66186ad09851f928e2b51b9793042d6e963def6f394b234"
    sha256 cellar: :any,                 ventura:       "b31e54b4643b071d8e5605c0a28ebcb817eaeb63486c51a2089102241e252b6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "428c6278734912b2bc40a385bb2108630a75e144d8458e827ab08ad7566d6c79"
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
