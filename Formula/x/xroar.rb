class Xroar < Formula
  desc "Dragon and Tandy 8-bit computer emulator"
  homepage "https://www.6809.org.uk/xroar/"
  url "https://www.6809.org.uk/xroar/dl/xroar-1.10.tar.gz"
  sha256 "b16b83f75a55e685658155e13ca393d5bc9553d120dd78a76febdd4a54ff9d58"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b4229edfc412c9e87bb0abdc4ed1cc74674ed5f30b3f82347dc3a5c3584e438"
    sha256 cellar: :any,                 arm64_sequoia: "454780323112a13c73a0b85f1b4fe4db122a5a5f1bf7f8d166d1e1c080ba00ce"
    sha256 cellar: :any,                 arm64_sonoma:  "1b29207cad93574f6eaf746f17ffa9006defcfff198dd02231960ea159582819"
    sha256 cellar: :any,                 sonoma:        "2d62e3579becc22cbc4f979fa20bfa1f940ed252105c6a25c5de9c30da009c0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92c34eff0e2de37007a49bef387f37c84b27fabbbdfb357b0ec0b9cafe4d9abb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6968c6150aa956c515d40c0e94a799824859d166a94405116bb91e2a2948f91f"
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
    output = shell_output("#{bin}/xroar -config-print")

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
