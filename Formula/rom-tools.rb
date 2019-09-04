class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0213.tar.gz"
  version "0.213"
  sha256 "19b71a8055b70729ca17c399c18ae1ea34cbd8993a2d5d1eba7d631b7cef82f4"
  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    sha256 "647246a3854c8cfbd22c9a3cc6c4fd7bd74cdc1a721da42a1f41c92e1bec99e9" => :mojave
    sha256 "3d4c79ef55a38da9423340f3b982d4cd9d787547d5cc6778843b703fcb8b2885" => :high_sierra
  end

  depends_on "asio" => :build
  depends_on "pkg-config" => :build
  depends_on "flac"
  # Need C++ compiler and standard library support C++14.
  # Build failure on Sierra, see:
  # https://github.com/Homebrew/homebrew-core/pull/39388
  depends_on :macos => :high_sierra
  depends_on "sdl2"
  depends_on "utf8proc"

  def install
    inreplace "scripts/src/osd/sdl.lua", "--static", ""
    system "make", "TOOLS=1",
                   "USE_LIBSDL=1",
                   "USE_SYSTEM_LIB_EXPAT=1",
                   "USE_SYSTEM_LIB_ZLIB=1",
                   "USE_SYSTEM_LIB_ASIO=1",
                   "USE_SYSTEM_LIB_FLAC=1",
                   "USE_SYSTEM_LIB_UTF8PROC=1"
    bin.install %w[
      aueffectutil castool chdman floptool imgtool jedutil ldresample ldverify
      nltool nlwav pngcmp regrep romcmp src2html srcclean testkeys unidasm
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
    assert_match "template", shell_output("#{bin}/src2html 2>&1", 1)
    system "#{bin}/srcclean"
    assert_match "architecture", shell_output("#{bin}/unidasm", 1)
  end
end
