class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0183.tar.gz"
  version "0.183"
  sha256 "c12b3051f2f11331a38f557eac7f3074166e48155133b2f3e7cc323df56ce8b0"
  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    sha256 "635950c0d3bb67baaa4dc9df87232e927816d5efaf868a87e503e5fb9c554f7f" => :sierra
    sha256 "96cf7d3c333e7a2ce30408efaa12d0ee3fcd400fb6590aaf3050535b40691ebf" => :el_capitan
    sha256 "42fd6a62c98c8b9e5f7e11d4b9f83fa1af4325f13c7506f27a076f2e22e3f70f" => :yosemite
  end

  depends_on :python => :build if MacOS.version <= :snow_leopard
  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "flac"
  depends_on "portmidi"

  def install
    inreplace "scripts/src/osd/sdl.lua", "--static", ""
    system "make", "TOOLS=1",
                   "PTR64=#{MacOS.prefer_64_bit? ? 1 : 0}", # for old Macs
                   "USE_LIBSDL=1",
                   "USE_SYSTEM_LIB_ZLIB=1",
                   "USE_SYSTEM_LIB_FLAC=1",
                   "USE_SYSTEM_LIB_PORTMIDI=1"
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
