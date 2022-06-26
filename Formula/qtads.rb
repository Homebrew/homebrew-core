class Qtads < Formula
  desc "TADS multimedia interpreter"
  homepage "https://realnc.github.io/qtads/"
  url "https://github.com/realnc/qtads/releases/download/v3.3.0/qtads-3.3.0-source.tar.xz"
  sha256 "02d62f004adbcf1faaa24928b3575a771d289df0fea9a97705d3bc528d9164a1"
  license "GPL-3.0-or-later"
  head "https://github.com/realnc/qtads.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "01775d9d59b935a88d278eafa80efc640b37b0bcca42b0209a51d5f480879ec4"
    sha256 cellar: :any,                 arm64_big_sur:  "d6784afbd739446332a78e1f901f06bda0d27ccb55a4843f3d2aa6a2a98bd3c7"
    sha256 cellar: :any,                 monterey:       "58e13943b5851bb624acd3b8476e332929372ca7278bed480a2472ac642be420"
    sha256 cellar: :any,                 big_sur:        "ff20c33e9aac5f4987ccd3012857580c8aa73a4b7e12e343da8e10f60de11bf3"
    sha256 cellar: :any,                 catalina:       "d3a01d88f22770acc001c6e3be86b0beba01086037a3d33c969d3d02abbba3bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "291e63bf93958811dff8036f06db1bdaf06967d193b632889852834959801489"
  end

  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "qt@5"
  depends_on "sdl2"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    sdl_sound_include = Formula["sdl_sound"].opt_include
    inreplace "qtads.pro",
      "$$T3DIR \\",
      "$$T3DIR #{sdl_sound_include}/SDL \\"

    args = ["DEFINES+=NO_STATIC_TEXTCODEC_PLUGINS"]
    args << "PREFIX=#{prefix}" unless OS.mac?

    system "qmake", *args
    system "make"

    if OS.mac?
      prefix.install "QTads.app"
      bin.write_exec_script "#{prefix}/QTads.app/Contents/MacOS/QTads"
    else
      system "make", "install"
    end

    man6.install "desktop/man/man6/qtads.6"
  end

  test do
    bin_name = OS.mac? ? "QTads" : "qtads"
    assert_predicate testpath/"#{bin}/#{bin_name}", :exist?, "I'm an untestable GUI app."
  end
end
