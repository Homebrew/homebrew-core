class Qtads < Formula
  desc "TADS multimedia interpreter"
  homepage "https://qtads.sourceforge.io/"
  license "GPL-3.0"
  revision 2
  head "https://github.com/realnc/qtads.git"

  stable do
    url "https://downloads.sourceforge.net/project/qtads/qtads-2.x/2.1.7/qtads-2.1.7.tar.bz2"
    sha256 "7477bb3cb1f74dcf7995a25579be8322c13f64fb02b7a6e3b2b95a36276ef231"

    # Remove for > 2.1.7
    # fix infinite recursion
    patch do
      url "https://github.com/realnc/qtads/commit/d22054b.patch?full_index=1"
      sha256 "e6af1eb7a8a4af72c9319ac6032a0bb8ffa098e7dd64d76da08ed0c7e50eaa7f"
    end

    # Remove for > 2.1.7
    # fix pointer/integer comparison
    patch do
      url "https://github.com/realnc/qtads/commit/46701a2.patch?full_index=1"
      sha256 "02c86bfa44769ec15844bbefa066360fb83ac923360ced140545fb782f4f3397"
    end

    # Fix "error: ordered comparison between pointer and zero"
    # Reported 11 Dec 2017 https://github.com/realnc/qtads/issues/7
    if DevelopmentTools.clang_build_version >= "900"
      patch do
        url "https://raw.githubusercontent.com/Homebrew/formula-patches/e189341/qtads/xcode9.diff"
        sha256 "2016fef6e867b7b8dfe1bd5db64d588161aad1357faa1962ee48edbe35042ddc"
      end
    end
  end

  # The first-party download page links to releases on GitHub, so we manually
  # check that for now. If the formula is modified in the future to use a
  # release from GitHub, this should be modified to use `url :stable`.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "435e78a2cbbac2b581aa335b6467a3c6cd89e65e2ecfa3f4b8865049c176b346"
    sha256 cellar: :any, big_sur:       "1b7ad03b5fc2ceab4f7d8ffa5c6abc5eaef6f1c23152110f4e76b98598b3ca49"
    sha256 cellar: :any, catalina:      "d9cde41ffc4ee4adf1b026b15bbd22e2bfdc8dd994866b007bff0936c4218608"
    sha256 cellar: :any, mojave:        "d4db6c775198a2052b34c67255bdc26d18605d80885eacc3a7f596e980f89e0f"
  end

  depends_on "pkg-config" => :build
  depends_on "qt@5"
  depends_on "sdl2"
  depends_on "sdl2_mixer"
  depends_on "sdl_sound"

  def install
    sdl_sound_include = Formula["sdl_sound"].opt_include
    inreplace "qtads.pro",
      "INCLUDEPATH += src $$T2DIR $$T3DIR $$HTDIR",
      "INCLUDEPATH += src $$T2DIR $$T3DIR $$HTDIR #{sdl_sound_include}/SDL"

    qt5 = Formula["qt@5"].opt_prefix
    system "#{qt5}/bin/qmake", "DEFINES+=NO_STATIC_TEXTCODEC_PLUGINS"
    system "make"
    prefix.install "QTads.app"
    bin.write_exec_script "#{prefix}/QTads.app/Contents/MacOS/QTads"
    man6.install "share/man/man6/qtads.6"
  end

  test do
    assert_predicate testpath/"#{bin}/QTads", :exist?, "I'm an untestable GUI app."
  end
end
