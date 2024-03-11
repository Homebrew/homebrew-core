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
    sha256 cellar: :any,                 arm64_sonoma:   "bb8d957ea0f1d9a74473d4ad5f8bbd7848161dfdc67a6a3a59434f2d2a6e7f89"
    sha256 cellar: :any,                 arm64_ventura:  "64ce404d040d15d331800bccfa3de1fa65cb77251817d004ee583a461abbac2f"
    sha256 cellar: :any,                 arm64_monterey: "32226195132b1cffc11411b90d1c3d48155b426368fe7d6a4910b9b305134abf"
    sha256 cellar: :any,                 sonoma:         "5453fa9b39052fbf5a4f6fd134b5142d67232398b851e2f9b74a49ef682863c0"
    sha256 cellar: :any,                 ventura:        "3bad335f286064b97f1558638db1f17cf7d96b29059ae8e21493d2eda79dd95e"
    sha256 cellar: :any,                 monterey:       "6bc4c766bd92304ba5790463bccdbf8c141c8c32c1e99c38037e18d5c566e854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f83fb3f00c7dc06b19a332234686a9d08e458c486dc7bcf109aae38d1586180a"
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
