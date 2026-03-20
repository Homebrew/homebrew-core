class Xroar < Formula
  desc "Dragon and Tandy 8-bit computer emulator"
  homepage "https://www.6809.org.uk/xroar/"
  url "https://www.6809.org.uk/xroar/dl/xroar-1.10.tar.gz"
  sha256 "b16b83f75a55e685658155e13ca393d5bc9553d120dd78a76febdd4a54ff9d58"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "52681ca01fcb75069b25d62f754db55d9c1968ba97302d808aa0819077b24091"
    sha256 cellar: :any,                 arm64_sequoia: "1dfac9438d100ba243eb330606532c68dcc2fb148761fed094a97c505ccd8e51"
    sha256 cellar: :any,                 arm64_sonoma:  "66b65b60b50cbace3336700d6f3958ecf13d2d7ff373afbc78b5496028874474"
    sha256 cellar: :any,                 sonoma:        "d1f01e6bbabcb9330824fb1c5a002d4bd9ec806b3a95b4d58e64ddd52ea94860"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0c1417b6d9167ea76ca199b4b29a041d964180753e51c42a2450af222d445be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e47407779ad729169ce38b140396558791b16ff01f6e2f1b32f37f70720c26ba"
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
