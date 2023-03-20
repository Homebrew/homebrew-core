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
    sha256 cellar: :any,                 arm64_ventura:  "a1e97e2c0ac9d8a3262eecddfc3b15e6eca278866ed96312aba26b1c1ae806e8"
    sha256 cellar: :any,                 arm64_monterey: "d4a0099787f26896eab9fe75d13bd0e865aced0fd9c416364cc3e86c42ce2de2"
    sha256 cellar: :any,                 arm64_big_sur:  "beb665f3d21cb1430fc5cdf3c2ff88587c7f85c66a43db219a4ff3d885a48cf9"
    sha256 cellar: :any,                 ventura:        "9175ecc03c81e56b4dcc503bc8ff9ea8eab038bf95885f71a001cb09d988e323"
    sha256 cellar: :any,                 monterey:       "d4241f19b233c4c0b9f49c876a52badc397304c2606b82ba2591a0e85fc0ad7e"
    sha256 cellar: :any,                 big_sur:        "59277331f90284a6fc9ca12f8e914e7390d1df7671fa942b9095041f7e9ec57d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6944b83ac20c0a6bfcb285405abe6e5d9c42567b7f1be839316255a48bd85940"
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
