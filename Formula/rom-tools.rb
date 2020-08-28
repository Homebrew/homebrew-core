class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0224.tar.gz"
  version "0.224"
  sha256 "3518e71ec20fbeac8ebe93f8ec856078b8288e19f0d7cb38959d4bde30cd2810"
  license "GPL-2.0-or-later"
  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    sha256 "4b20514f03365966c723bafcb33ea11e4b6f65fb41e31abd9de09113b26d9dd0" => :catalina
    sha256 "9bc473e2d0fd9b047d8136277f03bb20f750d87c13463342ba561029c9379277" => :mojave
    sha256 "11c3c02304835a62add02f11484c7c392905f16c5460d641550757fbaec79745" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
  depends_on "flac"
  # Need C++ compiler and standard library support C++17.
  depends_on macos: :high_sierra
  depends_on "sdl2"
  depends_on "utf8proc"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    # Cut sdl2-config's invalid option.
    inreplace "scripts/src/osd/sdl.lua", "--static", ""

    # Use bundled asio instead of latest version.
    # See: <https://github.com/mamedev/mame/issues/5721>
    system "make", "PYTHON_EXECUTABLE=#{Formula["python@3.8"].opt_bin}/python3",
                   "TOOLS=1",
                   "USE_LIBSDL=1",
                   "USE_SYSTEM_LIB_EXPAT=1",
                   "USE_SYSTEM_LIB_ZLIB=1",
                   "USE_SYSTEM_LIB_ASIO=",
                   "USE_SYSTEM_LIB_FLAC=1",
                   "USE_SYSTEM_LIB_UTF8PROC=1"
    bin.install %w[
      aueffectutil castool chdman floptool imgtool jedutil ldresample ldverify
      nltool nlwav pngcmp regrep romcmp srcclean testkeys unidasm
    ]
    bin.install "split" => "rom-split"
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
