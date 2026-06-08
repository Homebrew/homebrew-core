class Xroar < Formula
  desc "Dragon and Tandy 8-bit computer emulator"
  homepage "https://www.6809.org.uk/xroar/"
  url "https://www.6809.org.uk/xroar/dl/xroar-1.11.tar.gz"
  sha256 "70270805ebd52c0b62237cc2f28b32b5c7df9764d10a7c7190de584cfc6e95af"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b45f9f1610c5b78611a942d8d969c6c3e7639aa0584088e4d27c43edf1075282"
    sha256 cellar: :any,                 arm64_sequoia: "3ec966ecca99940d17b97bfd51da11c2f777a87c019f5019c7434d2f7259548e"
    sha256 cellar: :any,                 arm64_sonoma:  "0d3d8c27771dff6ce5f3a2ba51e0387ebf3747fc65a1210e1af32f485510a1c7"
    sha256 cellar: :any,                 sonoma:        "0faa323fba386d1c1fdf6c2eefb5cb5a5a3e237a28d98c4de41f33778ea2c45a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b75ec7faf16dea918b0330b9cfadef8dc9c64a1b1383fd03de0dc5303209ab70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d252d192d37f75cd552a1a0c6da5a8846f66d4534d52afb27912fd7888c45144"
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

  on_linux do
    depends_on "alsa-lib"
    depends_on "mesa"
    depends_on "pulseaudio"
    depends_on "zlib-ng-compat"
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
