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
    sha256 cellar: :any,                 arm64_monterey: "ee81b4a35b37b3917513e52e3330011529dc4911a1cbfe56117d7286e3b56bdc"
    sha256 cellar: :any,                 arm64_big_sur:  "efb0917e30907f43e0d75d4593842bc30f89694913d0fa4d6a78b312862cc9cd"
    sha256 cellar: :any,                 monterey:       "ce3ce044126f12c53557af8db60491b3196b4c5ceada3cc2f8ddd574e6b84c83"
    sha256 cellar: :any,                 big_sur:        "d3f92978a0454521d20577fda97c3cef034e60be673f06bcef5db44376e7ed3f"
    sha256 cellar: :any,                 catalina:       "16bb2be33f9757e197011ec42652b90e8220203cb6b59a261dfd2658707adc9e"
    sha256 cellar: :any,                 mojave:         "01215c3c22a58a47a1b4ff91e7a1558a301d0620c50b553f77f0fb30d75d8ae9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cefcbba0619133aba0182d27468c04b1daac381550d29e29bf1dfbc80a621569"
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
