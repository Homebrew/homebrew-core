class Qtads < Formula
  desc "TADS multimedia interpreter"
  homepage "https://realnc.github.io/qtads/"
  url "https://github.com/realnc/qtads/releases/download/v3.2.0/qtads-3.2.0-source.tar.xz"
  sha256 "382dbeb9af6ea5048ac19e7189bb862f81bc0f2e2e7ccad42d03985db12e5cc4"
  license "GPL-3.0-or-later"
  head "https://github.com/realnc/qtads.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "435e78a2cbbac2b581aa335b6467a3c6cd89e65e2ecfa3f4b8865049c176b346"
    sha256 cellar: :any, big_sur:       "1b7ad03b5fc2ceab4f7d8ffa5c6abc5eaef6f1c23152110f4e76b98598b3ca49"
    sha256 cellar: :any, catalina:      "d9cde41ffc4ee4adf1b026b15bbd22e2bfdc8dd994866b007bff0936c4218608"
    sha256 cellar: :any, mojave:        "d4db6c775198a2052b34c67255bdc26d18605d80885eacc3a7f596e980f89e0f"
  end

  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "qt@5"
  depends_on "sdl2"

  def install
    sdl_sound_include = Formula["sdl_sound"].opt_include
    inreplace "qtads.pro",
      "$$T3DIR \\",
      "$$T3DIR #{sdl_sound_include}/SDL \\"

    qt5 = Formula["qt@5"].opt_prefix
    system "#{qt5}/bin/qmake", "DEFINES+=NO_STATIC_TEXTCODEC_PLUGINS"
    system "make"
    prefix.install "QTads.app"
    bin.write_exec_script "#{prefix}/QTads.app/Contents/MacOS/QTads"
    man6.install "desktop/man/man6/qtads.6"
  end

  test do
    assert_predicate testpath/"#{bin}/QTads", :exist?, "I'm an untestable GUI app."
  end
end
