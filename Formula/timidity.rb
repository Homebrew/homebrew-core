class Timidity < Formula
  desc "Software synthesizer"
  homepage "https://timidity.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/timidity/TiMidity++/TiMidity++-2.15.0/TiMidity++-2.15.0.tar.bz2"
  sha256 "161fc0395af16b51f7117ad007c3e434c825a308fa29ad44b626ee8f9bb1c8f5"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/TiMidity%2B%2B[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "b7f6a933b163f87baad3e1799160fc42bf1b14829a5223e903ae38a26dc2c4c2" => :big_sur
    sha256 "4ebc752f9ca4fcfa88ade5f6806037678d855d97470adb5507c1290527fe6260" => :catalina
    sha256 "2cae56b69dc38af0de2d80816539ac5d6c78da535d20d63a2103dcf907ec9b80" => :mojave
    sha256 "563d4ffe26aff2b7b4453d5cb159cc596bae4f804cc977978cb01856184ed9c7" => :high_sierra
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
    system "./configure", "--disable-dependency-tracking",
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
