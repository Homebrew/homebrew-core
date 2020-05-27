class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0221.tar.gz"
  version "0.221"
  sha256 "8ead65f2585fc1330215e42db1d691f18497ff6d9e561d3cced54af599da4ac0"
  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    sha256 "24e42f2cf52bcd89e5745a91f5e7be284e51df786aa0d82bf48a3ccb7eaf09be" => :catalina
    sha256 "27805147c06c2195d2ef967d7ef3c0e2d4039aec766d0e4575febe23b3553d29" => :mojave
    sha256 "cb40e16fdca000fd6a311d33c02133faae496287e582cb23664d7e68167a4c1a" => :high_sierra
  end

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
                   "USE_SYSTEM_LIB_ASIO=0",
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
