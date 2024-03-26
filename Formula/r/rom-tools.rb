class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/refs/tags/mame0264.tar.gz"
  version "0.264"
  sha256 "3d9f69ed3ef7c1628d5714c8ae2695ea77b1a652a93347b2703f7c862299376e"
  license "GPL-2.0-or-later"
  head "https://github.com/mamedev/mame.git", branch: "master"

  livecheck do
    formula "mame"
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "689f46493cb52f61a35596c0de060c5bc07c845bce860ad2945a9ec3411b49f2"
    sha256 cellar: :any,                 arm64_ventura:  "c05d246aedc00df3b21eedf373f7b5ce475a799c341bf98ad26dce8db7f2edca"
    sha256 cellar: :any,                 arm64_monterey: "3934ad07ab118071230b2718eaed051aba4ded21f1cf0574bafccf0e9b492928"
    sha256 cellar: :any,                 sonoma:         "77d44bb794f8d0b011fba21fd350bc59e4a9b375122156c66f7aa19ea1c65791"
    sha256 cellar: :any,                 ventura:        "8e6dfee064f19d6e5116a1bec01ea9770e7bfbebaa21afc97e21374ce9bc9dd0"
    sha256 cellar: :any,                 monterey:       "f90a8ecdd6276eb8f2d8058b2066186ca7e1a64969f752d9be5406605dfc919c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a6a2627a81cbc766f618a1834cdebc30a82d27535263af76868467be89cb6d1"
  end

  depends_on "asio" => :build
  depends_on "pkg-config" => :build
  depends_on "flac"
  # Need C++ compiler and standard library support C++17.
  depends_on macos: :high_sierra
  depends_on "sdl2"
  depends_on "utf8proc"
  depends_on "zstd"

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
      USE_SYSTEM_LIB_ZSTD=1
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
