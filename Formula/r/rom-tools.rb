class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/refs/tags/mame0263.tar.gz"
  version "0.263"
  sha256 "2f380a7a9344711c667aef6014d522dd876db4c04f15dbab8d14bd3b2a0d4c8c"
  license "GPL-2.0-or-later"
  head "https://github.com/mamedev/mame.git", branch: "master"

  livecheck do
    formula "mame"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "70a9a74c896dfe5ed9d4b8adfd73a936c035dc3714eb20d50db8a0708b1b619e"
    sha256 cellar: :any,                 arm64_ventura:  "b31e250c3963524342f8df49f6076b896cb194029cf884ab080541dcff2db69b"
    sha256 cellar: :any,                 arm64_monterey: "21e0399d7ce6b57c5fced50aa064024706f78ea357f5203d6053b3b76ad77b06"
    sha256 cellar: :any,                 sonoma:         "1f1e4db1e52cb93d95f9f0cbbf7bc05b88071c3e6aae65c851ff9ef6ab32fd33"
    sha256 cellar: :any,                 ventura:        "526c3e89cf2a89e24abf8d1fc532abad99d5ad64bcfb0d28911d30c43482b03e"
    sha256 cellar: :any,                 monterey:       "b3171839a9a5fef09873f7c3000649d80d1964d342a9b901d4d1ff3f7a69b032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24fee93e031bebcf10d24b47cdd7bcbb074bd55d16f683e9d50037eab957b74d"
  end

  depends_on "asio" => :build
  depends_on "pkg-config" => :build
  depends_on "flac"
  # Need C++ compiler and standard library support C++17.
  depends_on macos: :high_sierra
  depends_on "sdl2"
  depends_on "utf8proc"

  uses_from_macos "python" => :build
  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "portaudio" => :build
    depends_on "portmidi" => :build
    depends_on "pulseaudio" => :build
    depends_on "qt@5" => :build
    depends_on "sdl2_ttf" => :build
  end

  fails_with gcc: "5" # for C++17
  fails_with gcc: "6"

  def install
    # Cut sdl2-config's invalid option.
    inreplace "scripts/src/osd/sdl.lua", "--static", ""

    args = %W[
      PYTHON_EXECUTABLE=#{which("python3")}
      TOOLS=1
      EMULATOR=0
      USE_LIBSDL=1
      USE_SYSTEM_LIB_EXPAT=1
      USE_SYSTEM_LIB_ZLIB=1
      USE_SYSTEM_LIB_ASIO=1
      USE_SYSTEM_LIB_FLAC=1
      USE_SYSTEM_LIB_UTF8PROC=1
      VERBOSE=1
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
    system bin/"castool"
    assert_match "chdman info", shell_output("#{bin}/chdman help info", 1)
    system bin/"floptool"
    system bin/"imgtool", "listformats"
    system bin/"jedutil", "-viewlist"
    assert_match "linear equation", shell_output("#{bin}/ldresample 2>&1", 1)
    assert_match "avifile.avi", shell_output("#{bin}/ldverify 2>&1", 1)
    system bin/"nltool", "--help"
    system bin/"nlwav", "--help"
    assert_match "image1", shell_output("#{bin}/pngcmp 2>&1", 10)
    assert_match "summary", shell_output("#{bin}/regrep 2>&1", 1)
    system bin/"romcmp"
    system bin/"rom-split"
    system bin/"srcclean"
    assert_match "architecture", shell_output("#{bin}/unidasm", 1)
  end
end
