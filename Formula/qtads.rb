class Qtads < Formula
  desc "TADS multimedia interpreter"
  homepage "https://qtads.sourceforge.io/"
  head "https://github.com/realnc/qtads.git"

  stable do
    url "https://downloads.sourceforge.net/project/qtads/v3.0.0/qtads-3.0.0-source.tar.xz"
    sha256 "430b5de04d2d2cafe4cd2614cd034c5fb71e0ba39ec1e5d058613b43a92e0407"
  end

  bottle do
    cellar :any
    sha256 "ddc00587ac0d9f3ebcd6f0bac9e8a4207f9ae930a6646e4f3ce60d186abdc832" => :catalina
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
      "$$T3DIR \\",
      "$$T3DIR #{sdl_sound_include}/SDL \\"

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
