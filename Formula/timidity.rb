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
    rebuild 1
    sha256 arm64_monterey: "207353939838f83aec0c2fd6f68363f7f961f7f08d69f317aecfece613732583"
    sha256 arm64_big_sur:  "b6a5b9258ca86e58a8f535a3d7d2c8c51faf608df5bc119b37d99dccfb549142"
    sha256 monterey:       "61d1189c1afa7ca17680f8e8bcfc4f5277f9e30e7b2e47f89a246714606059e3"
    sha256 big_sur:        "513868c11a5ecbc1b8044eea517c19490858173d6b61f0245c54f9b061956237"
    sha256 catalina:       "31a2aaefcf9e293bbfce210de4a0521bdf6df205f4fb5bb009f98ad1c01bd6f1"
    sha256 mojave:         "9dec67aa3004c6ad228dd143eea25c2db9fc568269cae1f80320c00addc3c782"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

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
    system "./autogen.sh" if Hardware::CPU.arm?
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
