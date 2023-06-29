class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0256.tar.gz"
  version "0.256"
  sha256 "7523c46684043cc9e2af242aa7e31476b076fed492c3ae4ae0c964aafd65f659"
  license "GPL-2.0-or-later"
  head "https://github.com/mamedev/mame.git", branch: "master"

  livecheck do
    formula "mame"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "790ee0ae00b02fbb58a7a2f9c5466cd5ef93096297308c4eb4d7f0e6cb70febc"
    sha256 cellar: :any,                 arm64_monterey: "981f26d40c57641d36fd00b4f6b8da5cf2ad2a178a11b64b479658c00bdcd137"
    sha256 cellar: :any,                 arm64_big_sur:  "abeb26626d789c62b7d7cf6f995dcb94bfd77f653b3a6420153ca600fa83ab20"
    sha256 cellar: :any,                 ventura:        "0ac5a1de991ce8b65917c47f9de3ba1686c8a69d6b90c0d9791e385f2de2ae4c"
    sha256 cellar: :any,                 monterey:       "ec5a2c6a3d38b4eeadfef4550e1fab1c1704162e1d8928b38613c7ebb5403d6f"
    sha256 cellar: :any,                 big_sur:        "181df9aba460dae12732904ee351b9ad24a0fe15fc7e0f7031d9f37bdead7905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ce17664cf9c28b845c231e857918b88a46d54255ae60d74110109873548cfca"
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
