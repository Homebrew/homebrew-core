class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0250.tar.gz"
  version "0.250"
  sha256 "949ec937b1df50af519f594d690832ca56342983f519b62a4be9c2c0b595d3ad"
  license "GPL-2.0-or-later"
  head "https://github.com/mamedev/mame.git", branch: "master"

  livecheck do
    formula "mame"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "24652c65f1ee3222be28ec7cf346a75775d153cd87a033e3cb075b8bb1bceb17"
    sha256 cellar: :any,                 arm64_monterey: "abf0bbb7573fa3fcb4461bd6940bd0076f09e034ff904216335327a1a77566e2"
    sha256 cellar: :any,                 arm64_big_sur:  "ac035488c6d7d2c35efdabf1bc4c0576fc15db98f12a8fa0e549be66f97887d9"
    sha256 cellar: :any,                 ventura:        "f217ff2ff54de6532a2b058b524d455cce32a662b36aefa253c39df6d480d4f8"
    sha256 cellar: :any,                 monterey:       "23d69fce769124a0fae6bb8ed9fda32359cce1b375e89f12a0c7ca457abcef1b"
    sha256 cellar: :any,                 big_sur:        "2cf5ac37f45a361a61b2ff812826f771c5f019401454171c99ac7c220e576396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0553a5f7dea767260190333fb6796a77a8a78def489d620d2e70070c3debbd69"
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

  # Fixes a segfault; will be in the next release.
  # https://github.com/mamedev/mame/issues/10594
  patch do
    url "https://github.com/mamedev/mame/commit/0d93398fb3d48e88209a4f3e07fd389522585ab6.patch?full_index=1"
    sha256 "d4ad64701fac3e6176d69a2052d3bee7eee69061323a57edb815d07d2d2c31d0"
  end

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
