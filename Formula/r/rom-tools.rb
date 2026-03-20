class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https://www.mamedev.org/"
  url "https://github.com/mamedev/mame/archive/refs/tags/mame0286.tar.gz"
  version "0.286"
  sha256 "ef05eb7521c841e7571b57cdd67bb729fb60ea76725a8fe27e74d805bbab9580"
  license "GPL-2.0-or-later"
  head "https://github.com/mamedev/mame.git", branch: "master"

  livecheck do
    formula "mame"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5b5c8d91efbea5a5da2cc7e816d09fe4b118115590bbb5e45d44a3671eda0cbf"
    sha256 cellar: :any,                 arm64_sequoia: "9787600a6a1fa2b7d8338c8d2138d9d091f1f1f4445f1675f7f237d945b1b48a"
    sha256 cellar: :any,                 arm64_sonoma:  "901f6b61da192d76fcdbd75384a7d74d658b759d035f4069c3525233ccb394e3"
    sha256 cellar: :any,                 sonoma:        "196e97e1f51ef78b61daa4976e1435e83c5598700a6d64249cff29076300704f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb0e6fbd357bf02c9361275a4efe55b87659abe2c45cbcd8447441800ba0b007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f03e3ff456f73878f7c97cdf0c406db9273bf488e128445f46de915cb0ce846"
  end

  depends_on "asio" => :build
  depends_on "pkgconf" => :build
  depends_on "flac"
  depends_on "sdl3"
  depends_on "utf8proc"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "expat"

  on_linux do
    depends_on "portaudio" => :build
    depends_on "portmidi" => :build
    depends_on "pulseaudio" => :build
    depends_on "qtbase" => :build
    depends_on "sdl3_ttf" => :build
    depends_on "zlib-ng-compat"
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
      OSD=sdl3
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
