class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0203.tar.gz"
  version "0.203"
  sha256 "e17aa95f8897217d433e44e2f4b75ac7b5e13184549b7d14098d52652b7eb49a"
  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5c554cc10c074fedf7250701c3f7d94eba5227051f5a6a798bfca9d60ebfb849" => :mojave
    sha256 "729ea0c9bd797c0a99f87bc8c65d23300000f813919f02c35a432b40ef6052d6" => :high_sierra
    sha256 "f631daab1b28dc79afd4e9b4cf525273f27f440b13de253941f324b8c452fcea" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "portmidi"
  depends_on "sdl2"
  depends_on "utf8proc"

  def install
    inreplace "scripts/src/osd/sdl.lua", "--static", ""
    system "make", "TOOLS=1",
                   "PTR64=#{MacOS.prefer_64_bit? ? 1 : 0}", # for old Macs
                   "USE_LIBSDL=1",
                   "USE_SYSTEM_LIB_EXPAT=1",
                   "USE_SYSTEM_LIB_ZLIB=1",
                   "USE_SYSTEM_LIB_FLAC=1",
                   "USE_SYSTEM_LIB_PORTMIDI=1",
                   "USE_SYSTEM_LIB_UTF8PROC=1"
    bin.install %w[
      aueffectutil castool chdman floptool imgtool jedutil ldresample
      ldverify nltool nlwav pngcmp regrep romcmp src2html srcclean unidasm
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
