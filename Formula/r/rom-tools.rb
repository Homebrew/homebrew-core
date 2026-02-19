class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https://www.mamedev.org/"
  url "https://github.com/mamedev/mame/archive/refs/tags/mame0285.tar.gz"
  version "0.285"
  sha256 "2b7ed1553ddf434692f62ded87b296931968d55e15f786a8588102880851f41c"
  license "GPL-2.0-or-later"
  head "https://github.com/mamedev/mame.git", branch: "master"

  livecheck do
    formula "mame"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "6b154f182bd737e6a91409fb8ab436d08177ce261e7316f6a6a0f346cd700387"
    sha256 cellar: :any,                 arm64_sequoia: "a85a3fe157e251a4446bfdc3d480daaec4362471af15bf59620d5425fd240f17"
    sha256 cellar: :any,                 arm64_sonoma:  "80054471fd6b2eb8bd9c71174325a54ac0ea2ee2540a3eacd66e05c149f111e1"
    sha256 cellar: :any,                 sonoma:        "c9bff74abb0f11defc3745fa45e34799f41ba5aad0f7cbe27867f8359f08420d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "008f6ffc3fc8f628d83a8176cba9ae8d37f0e4cc787dd9db48d4d9463a9fd2d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5394740275d3b0cc447d08eeb692784732bf4d75dcdf35f6db42fc96b38ccd0"
  end

  depends_on "asio" => :build
  depends_on "pkgconf" => :build
  depends_on "flac"
  depends_on "sdl2"
  depends_on "utf8proc"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "expat"

  on_linux do
    depends_on "portaudio" => :build
    depends_on "portmidi" => :build
    depends_on "pulseaudio" => :build
    depends_on "qtbase" => :build
    depends_on "sdl2_ttf" => :build
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
