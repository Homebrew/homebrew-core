class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0258.tar.gz"
  version "0.258"
  sha256 "aca1365f3e1a1c8fe1638206f1c6176da08cbe686586c55355068179c023096b"
  license "GPL-2.0-or-later"
  head "https://github.com/mamedev/mame.git", branch: "master"

  livecheck do
    formula "mame"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33db643d169e651cf0e9c2eba975d6227514519c81f2e3884a100f73f1f0d8e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96a7ba794c6fa5fddc96df0cbedfb85a0ca6b534c8f17f73762e70bc5ff8fe58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ac2dad72a7389d65fdce04e241e60e6a65a1a6cab9e6be14c9169400ef5a1af"
    sha256 cellar: :any_skip_relocation, ventura:        "ab541e69c3a4b2c706c9a31bcba7b491daced3210676c32fa72d6beb1fe3ee52"
    sha256 cellar: :any_skip_relocation, monterey:       "c89e0f63e8a670126ddd5fe0cf86bcd99489d3e7968c5aece6351d3684c6ff6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a505275add4ebc5d01d793bedd2896cb0af901562bd9eb9452b7bb83ec7d65c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b21fea31c09fac82331c57bd2011a3da61d484a65636b4890c8f9d200c28887e"
  end

  depends_on "asio" => :build
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

    args = %W[
      PYTHON_EXECUTABLE=#{which("python3.11")}
      TOOLS=1
      USE_LIBSDL=1
      USE_SYSTEM_LIB_EXPAT=1
      USE_SYSTEM_LIB_ZLIB=1
      USE_SYSTEM_LIB_ASIO=1
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
