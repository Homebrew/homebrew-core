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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "9299d3c5b8a51eaf92592724c056f07d0e5edfc8094464fef736f11d24113c11"
    sha256 cellar: :any,                 arm64_monterey: "0e30ba9d9f377dcf72aba30d61c6afbe3c36d5c371776ef8c52115e48021ba7f"
    sha256 cellar: :any,                 arm64_big_sur:  "7c323cae1a69574d5b699a5c5204b3b11878c26f86ce74bb61d0a84761555331"
    sha256 cellar: :any,                 ventura:        "05dc178c3844cbc7a10e4977c948db84e803f52a9e23b07c25374caa32932f09"
    sha256 cellar: :any,                 monterey:       "b2c94ccf083bbaf35d5e2417295996d4e3cfedca0ecc403feaff940646025ad0"
    sha256 cellar: :any,                 big_sur:        "f18e08b6d576a0d634602217c7ae797e34d39d527351e1be7b51724c069493ce"
    sha256 cellar: :any,                 catalina:       "ae983130a47c5061331a894e8f0ae509db915bb1a3fe80bdd1c6d6639389478a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce6ce65758aeb88826b2fc92fb98419e063cf3e5dbcc19613abab7f868faefb8"
  end

  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "qt@5"
  depends_on "sdl2"

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
