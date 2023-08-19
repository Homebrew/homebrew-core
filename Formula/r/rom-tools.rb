class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0257.tar.gz"
  version "0.257"
  sha256 "e3107012ce80bff10cef7cab6ad8290f97cf1bc978e67ae806aa1a0c100daaa2"
  license "GPL-2.0-or-later"
  head "https://github.com/mamedev/mame.git", branch: "master"

  livecheck do
    formula "mame"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e0bbbd32b6598d8e77cc43a0a835f6a6cbbdb0dfc816e7a4df375454573fc2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5e15d7854579356d89db0366f341defb7742115bb762da1f4fa22496a471603"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26de20a92c05837389391392f0115de8d6d8c964a83ab472eee9fcdc513dc25d"
    sha256 cellar: :any_skip_relocation, ventura:        "5a6aaafb7fa10b46211bf2824b235f9c792a64be60fae905f5bff970608c6846"
    sha256 cellar: :any_skip_relocation, monterey:       "5a635da8b6acaffa971bb5dcb9b91096e19f96f4a1316e9257f6189c7f98a8c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbec0aca1a7158a1e82be6734257fc28afa7cc0a7e346e98279dc34ce748f8a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b62e024d31a4e77e19014bacfb61572399a706759032a19dd13b71116dbec3f5"
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
