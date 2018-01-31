class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0194.tar.gz"
  version "0.194"
  sha256 "1faffab72d0d671232a14c73f6e0bec720e086af5c81f8e9c235c314123e761d"
  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    sha256 "e1477f59f31781b62a95a15674239e1ffe4b21ba534f3eeebacf66c6a1a4784c" => :high_sierra
    sha256 "ffff6087f7d6ac0fea6cdd2742aa054450f0bbc933c340444a25aaec456105c6" => :sierra
    sha256 "80c04fae59831f7ba476a008b989e2551d95d76b8096f867f0544d4b04d9bc97" => :el_capitan
  end

  depends_on "python" => :build if MacOS.version <= :snow_leopard
  depends_on "pkg-config" => :build
  depends_on "sdl2"
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
