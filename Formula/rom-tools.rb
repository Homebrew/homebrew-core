class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0252.tar.gz"
  version "0.252"
  sha256 "9d6365fed1c5f6a7a854d5489df4c70300d01d2aabf6764b0e2476b59babc13e"
  license "GPL-2.0-or-later"
  head "https://github.com/mamedev/mame.git", branch: "master"

  livecheck do
    formula "mame"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e9d2b0b44131f3f2ba7680ef195459dfb903973f81cebdcda35774017768b520"
    sha256 cellar: :any,                 arm64_monterey: "36105462443d01f64edeae59ca24278126e01eb588f04be7a7372ee0fe547237"
    sha256 cellar: :any,                 arm64_big_sur:  "e149f839929d52479426b87a87bfd79836405c1dc91b4296c90e0aafbfd6f052"
    sha256 cellar: :any,                 ventura:        "5dccb2b440e6cd46b07378da92b449f047327f68cd3164f704b7fe2090668c51"
    sha256 cellar: :any,                 monterey:       "8921eb1c2f49bc656dfb570c30a28bbcd2c03e1a9abe2a37a67970e7c9dee458"
    sha256 cellar: :any,                 big_sur:        "637eaa8931b215f52b9dbaa29cbc62795c3e8e9c8c3a048592cba7256229e567"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14321701dc756cf00a237f22ed2aa567504fb4f313fd1d1b4728519c0c6860a3"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
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
  end

  fails_with gcc: "5" # for C++17
  fails_with gcc: "6"

  def install
    # Cut sdl2-config's invalid option.
    inreplace "scripts/src/osd/sdl.lua", "--static", ""

    # Use bundled asio instead of latest version.
    # See: <https://github.com/mamedev/mame/issues/5721>
    args = %W[
      PYTHON_EXECUTABLE=#{which("python3.11")}
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
