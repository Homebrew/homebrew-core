class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0248.tar.gz"
  version "0.248"
  sha256 "7eef82527a4b66647e02625948d42e3502f13183192ea48e6fc2786d6f9222a0"
  license "GPL-2.0-or-later"
  head "https://github.com/mamedev/mame.git", branch: "master"

  livecheck do
    formula "mame"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1bad9b386682f272fc587a1cbbdba99d78fdf3172b9fb8222d3a54b6509d626e"
    sha256 cellar: :any,                 arm64_monterey: "e5651565de855eb52c359131ade101fb57328fb505692f83e93ab300b9cf9d1b"
    sha256 cellar: :any,                 arm64_big_sur:  "b1ee796bf7cdcda4a07e53426fa135ef5c04d6632a16d5b792cf0f7d4f686ce0"
    sha256 cellar: :any,                 ventura:        "8eee768aaf26a0fc4b31c991150687cb116e8888b71dd2cb71db72e38cd56330"
    sha256 cellar: :any,                 monterey:       "596041988acaee75e67a3d0f83233f394bad5f36293f975f5b7b624a785f13c3"
    sha256 cellar: :any,                 big_sur:        "700e727f57c1f103aa9f0ecb03b6dfc2743b27dad0a6321dfad572cfd74ac24f"
    sha256 cellar: :any,                 catalina:       "c14aede4a70676eb262bc991005c2ed9bbaeb58e40d3febc8f7d24f017474016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c53bedf9eef70fd601ec79b586b016c2ab269246de6cdd937f6a2664b0a58dd4"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
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
      PYTHON_EXECUTABLE=#{which("python3.10")}
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
