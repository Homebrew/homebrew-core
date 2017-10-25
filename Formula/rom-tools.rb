class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0191.tar.gz"
  version "0.191"
  sha256 "e1faed5ee39e977d9a4e60e439c4d36d55a476dbe70a3e8fbe6aadb2a63b1e31"
  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    sha256 "4bb829974439fc640237b9848b4ebf734320b97dad1654ab8eca30203b962b74" => :high_sierra
    sha256 "88826bf28d9a9f677a892724b0e2fc56ba2c570947355cbffa26f7fca8c0bcbc" => :sierra
    sha256 "337118ef08cf7a0d07c16f039e7eeba62cf37bb3c2aa21aa19f9034ced531df7" => :el_capitan
  end

  depends_on :python => :build if MacOS.version <= :snow_leopard
  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "expat"
  depends_on "flac"
  depends_on "portmidi"
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
