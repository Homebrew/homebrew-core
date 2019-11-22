class Timidity < Formula
  desc "Software synthesizer"
  homepage "https://timidity.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/timidity/TiMidity++/TiMidity++-2.15.0/TiMidity++-2.15.0.tar.bz2"
  sha256 "161fc0395af16b51f7117ad007c3e434c825a308fa29ad44b626ee8f9bb1c8f5"

  bottle do
    sha256 "3af812745e3ce97091362541143f4f019d39c30fba5adef4922bddd146671063" => :catalina
    sha256 "9fbf48450ffbdc5920914f0b1ba2b845504b0621b9bf76f3e21ec4cd0fe97da8" => :mojave
    sha256 "f8ce899eb5c5d67e78e713ec18bdc385ce388b43b425bd05bc9ebedf86be36ef" => :high_sierra
    sha256 "53406bf74847960d1c1871975a76175638e906225c28e40e0b930a557ceabb52" => :sierra
  end

  depends_on "flac"
  depends_on "libao"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "speex"

  resource "freepats" do
    url "https://freepats.zenvoid.org/freepats-20060219.zip"
    sha256 "532048a5777aea717effabf19a35551d3fcc23b1ad6edd92f5de1d64600acd48"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--enable-audio=darwin,vorbis,flac,speex,ao"
    system "make", "install"

    # Freepats instrument patches from https://freepats.zenvoid.org/
    (share/"freepats").install resource("freepats")
    pkgshare.install_symlink share/"freepats/Tone_000",
                             share/"freepats/Drum_000",
                             share/"freepats/freepats.cfg" => "timidity.cfg"
  end

  test do
    system "#{bin}/timidity"
  end
end
