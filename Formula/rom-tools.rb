class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0244.tar.gz"
  version "0.244"
  sha256 "843c917edc46008a27b439a1fc66fc12a27c84e55e08753b963789e5614cebf7"
  license "GPL-2.0-or-later"
  head "https://github.com/mamedev/mame.git", branch: "master"

  livecheck do
    formula "mame"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "34f4fab26e97d7e15000047848963032db3594b04f3d76520779840d0b3d2b42"
    sha256 cellar: :any,                 arm64_big_sur:  "f7f8991916c44adb65f08f38f34b8ef73bd1b2013f1942e04f8082d0b8fd2786"
    sha256 cellar: :any,                 monterey:       "4b57b97eef348e30932f9b1299435cbca13627c6d2540daec19a1cbd400fc2ba"
    sha256 cellar: :any,                 big_sur:        "6a2f887c611ceba1707168b0aad6a734fd6dfba68416c2a958af836d7d3d032b"
    sha256 cellar: :any,                 catalina:       "5dd0271e37131fbfa8bb205d0ac3822f87e2d9b7cc70da12bc6ccd666dd45886"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "178ffc8c6e16692e498383cef4ab695423d253ca16ef947f9d0f3603ca724766"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "flac"
  # Need C++ compiler and standard library support C++17.
  depends_on macos: :high_sierra
  depends_on "sdl2"
  depends_on "utf8proc"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "portaudio" => :build
    depends_on "portmidi" => :build
    depends_on "pulseaudio" => :build
    depends_on "qt@5" => :build
    depends_on "sdl2_ttf" => :build
    depends_on "gcc" # for C++17
  end

  fails_with gcc: "5"
  fails_with gcc: "6"

  # Apply upstream commit to fix build with newer GCC.
  # Remove with next release.
  patch do
    url "https://github.com/mamedev/mame/commit/034e0d2c87a16e90783f742f39850dc7d85def1f.patch?full_index=1"
    sha256 "cc7da44c9ca8caca26756175340644e1284a6d3692a1aa7320e85167a31e85c8"
  end

  def install
    # Cut sdl2-config's invalid option.
    inreplace "scripts/src/osd/sdl.lua", "--static", ""

    # Use bundled asio instead of latest version.
    # See: <https://github.com/mamedev/mame/issues/5721>
    args = %W[
      PYTHON_EXECUTABLE=#{which("python3")}
      TOOLS=1
      USE_LIBSDL=1
      USE_SYSTEM_LIB_EXPAT=1
      USE_SYSTEM_LIB_ZLIB=1
      USE_SYSTEM_LIB_ASIO=
      USE_SYSTEM_LIB_FLAC=1
      USE_SYSTEM_LIB_UTF8PROC=1
    ]
    if OS.linux?
      args << "USE_SYSTEM_LIB_PORTAUDIO=1"
      args << "USE_SYSTEM_LIB_PORTMIDI=1"
    end
    system "make", *args

    bin.install %w[
      castool chdman floptool imgtool jedutil ldresample ldverify
      nltool nlwav pngcmp regrep romcmp srcclean testkeys unidasm
    ]
    bin.install "split" => "rom-split"
    bin.install "aueffectutil" if OS.mac?
    man1.install Dir["docs/man/*.1"]
  end

  # Needs more comprehensive tests
  test do
    # system "#{bin}/aueffectutil" # segmentation fault
    system "#{bin}/castool"
    assert_match "chdman info", shell_output("#{bin}/chdman help info", 1)
    system "#{bin}/floptool"
    system "#{bin}/imgtool", "listformats"
    system "#{bin}/jedutil", "-viewlist"
    assert_match "linear equation", shell_output("#{bin}/ldresample 2>&1", 1)
    assert_match "avifile.avi", shell_output("#{bin}/ldverify 2>&1", 1)
    system "#{bin}/nltool", "--help"
    system "#{bin}/nlwav", "--help"
    assert_match "image1", shell_output("#{bin}/pngcmp 2>&1", 10)
    assert_match "summary", shell_output("#{bin}/regrep 2>&1", 1)
    system "#{bin}/romcmp"
    system "#{bin}/rom-split"
    system "#{bin}/srcclean"
    assert_match "architecture", shell_output("#{bin}/unidasm", 1)
  end
end
