class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https://www.mamedev.org/"
  url "https://github.com/mamedev/mame/archive/refs/tags/mame0282.tar.gz"
  version "0.282"
  sha256 "730d6264f0851de521ca03b71f8556f2b31b8f06d415b52d1ba31aafff9f6c3f"
  license "GPL-2.0-or-later"
  head "https://github.com/mamedev/mame.git", branch: "master"

  livecheck do
    formula "mame"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ab730186c3eb23fcd1d52fefe129313f243d2c18e733c382ecc47f4fe4a96edb"
    sha256 cellar: :any,                 arm64_sequoia: "c8955c9ea029a70327b8457aed2e97c4d5986acc049b9a19d0ed4608434e72f1"
    sha256 cellar: :any,                 arm64_sonoma:  "22100bd93d888d561a19084b67d4fff1e5a29351a07ed29b1e8731b7b6a81b54"
    sha256 cellar: :any,                 sonoma:        "d2e968b42f427a40bbfabb70f93426d78853c4bf2258198e9a873fd7228c1c1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "257adf3b455535c4c9abdbfd1c1fc7822dc2b3cbb8b7f18141826ff1180640ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77a1d83070a25ce353ddd046672bc7e8e8795648179098121358099424e544d8"
  end

  depends_on "asio" => :build
  depends_on "pkgconf" => :build
  depends_on "flac"
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
    depends_on "qtbase" => :build
    depends_on "sdl2_ttf" => :build
  end

  def install
    ENV["QT_HOME"] = Formula["qtbase"].opt_prefix if OS.linux?

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
