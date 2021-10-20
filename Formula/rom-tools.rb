class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  # NOTE: Please keep these values in sync with mame.rb when updating.
  url "https://github.com/mamedev/mame/archive/mame0236.tar.gz"
  version "0.236"
  sha256 "c76b973d786311f86922101ab0050dac90af9b0fd614a33c20231e3451c7b2dd"
  license "GPL-2.0-or-later"
  head "https://github.com/mamedev/mame.git", branch: "master"

  livecheck do
    formula "mame"
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "c6a21882625c804cb4d71f4a92b971ba6089ec09fce1a2df980b0f2f0a7a4d6f"
    sha256 cellar: :any,                 big_sur:       "32e98070f0f91e994dff48f5d899171d0ecafedce82162e5451d390923b10187"
    sha256 cellar: :any,                 catalina:      "ba5f16986dc9b1e512ae0d19f8b11448e788ae8c678d8e95aa468fd1b23f8b18"
    sha256 cellar: :any,                 mojave:        "7c9e3e329e515cc669f2df9049a75dd757ca0667e4d7455249a711154385e893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c160755d1fc9d7101fd7d6047131e8b95fccf75425753e0fe4f74e210c1508a8"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
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

  def install
    # Cut sdl2-config's invalid option.
    inreplace "scripts/src/osd/sdl.lua", "--static", ""

    # Use bundled asio instead of latest version.
    # See: <https://github.com/mamedev/mame/issues/5721>
    args = %W[
      PYTHON_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3
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
