class Qtads < Formula
  desc "TADS multimedia interpreter"
  homepage "https://qtads.sourceforge.io/"
  revision 1
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

  bottle do
    cellar :any
    sha256 "3158fb6eb3d97f548c908983348e221ee190835bda5ce70704747117ecf7611d" => :mojave
    sha256 "ef218d294d01133003c6e52fc32f9482726d6f237b3b5b90add019960ffe9eb2" => :high_sierra
    sha256 "51fff5c39b8c234bb72b9a3865f7a067fb2dab902316c7943261ba66ed98ab19" => :sierra
    sha256 "fe8ab65019c324c13c9024291b3e6288aff3ec28049a0cf321da421b4c28f0f6" => :el_capitan
    sha256 "e2383ed761b051e337ed2a4a4162655cb9eaa19ed8ab0666e8a7d1efa236b9b2" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "qt"
  depends_on "sdl2"
  depends_on "sdl2_mixer"
  depends_on "sdl_sound"

  def install
    sdl_sound_include = Formula["sdl_sound"].opt_include
    inreplace "qtads.pro",
      "INCLUDEPATH += src $$T2DIR $$T3DIR $$HTDIR",
      "INCLUDEPATH += src $$T2DIR $$T3DIR $$HTDIR #{sdl_sound_include}/SDL"

    system "qmake", "DEFINES+=NO_STATIC_TEXTCODEC_PLUGINS"
    system "make"
    prefix.install "QTads.app"
    bin.write_exec_script "#{prefix}/QTads.app/Contents/MacOS/QTads"
    man6.install "share/man/man6/qtads.6"
  end

  test do
    assert_predicate testpath/"#{bin}/QTads", :exist?, "I'm an untestable GUI app."
  end
end
