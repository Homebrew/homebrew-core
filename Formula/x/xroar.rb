class Xroar < Formula
  desc "Dragon and Tandy 8-bit computer emulator"
  homepage "https://www.6809.org.uk/xroar/"
  url "https://www.6809.org.uk/xroar/dl/xroar-1.13.tar.gz"
  sha256 "e2708af6d819387714752669136c63016498b63df31bf3214f4b3dfa6188d27c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "526193c1cca92e7201881581a81b946573ab77e04adf0edaec564d33d168fd59"
    sha256 cellar: :any, arm64_tahoe:       "cddf9fbd9d1dff6b41b3a5abfb3dfebb5def5170efbf55e7eb2ef988700b82c6"
    sha256 cellar: :any, arm64_sequoia:     "839a20b7c3de18a075f6a161f8d3cf371c89df618797f660016c708dce988385"
    sha256 cellar: :any, arm64_linux:       "5a8c2be852a7d30a7436e4e35fb7539de32138d3f3d5d9f20b68a819b9f01140"
    sha256 cellar: :any, x86_64_linux:      "0c45c11cf44219cf8f733fac8b4ffb2ce9209a3507c66df70539790ea7886de8"
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
  depends_on "sdl2-compat"

  on_linux do
    depends_on "alsa-lib"
    depends_on "mesa"
    depends_on "pulseaudio"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
