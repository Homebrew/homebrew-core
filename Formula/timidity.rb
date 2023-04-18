class Timidity < Formula
  desc "Software synthesizer"
  homepage "https://timidity.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/timidity/TiMidity++/TiMidity++-2.15.0/TiMidity++-2.15.0.tar.bz2"
  sha256 "161fc0395af16b51f7117ad007c3e434c825a308fa29ad44b626ee8f9bb1c8f5"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/TiMidity%2B%2B[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "683ed0581cef4c5527eea9482440ced7ae6c7dfd9b09a7bf7207f7f2a49b5faf"
    sha256 arm64_monterey: "215a1a95a53e1f8f136d96107135133375060c7c5f97e37ea61224c152cfd17e"
    sha256 arm64_big_sur:  "8e0f3d548b9566140d1c2f1f12ebb221260e062060eb2c374fabc998efab5d1d"
    sha256 ventura:        "d5cd5ebef9d74d9353dfe729c02b6b583c767e0426d3c12ca8b4da07ff8e25dc"
    sha256 monterey:       "7aeddb0863d411f946560c9a25606de141db96a596f63bbd80d19ccebbb4b4ec"
    sha256 big_sur:        "2feeeebd41909eb7296bbe8fd7b09b99e49bb4f52341eed107d0cb423a673793"
    sha256 catalina:       "761a0dd6e3c1499005cc2722a5cef8e8529216c8c668c18b9b1fc8711ea409f4"
    sha256 x86_64_linux:   "bfb585896b4dcdc915adefea538fcb691a213a7f672e10d24b5ff34f95139a9a"
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
    audio_options = %w[
      vorbis
      flac
      speex
      ao
    ]
    audio_options << "darwin" if OS.mac?

    system "./autogen.sh" if Hardware::CPU.arm?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--enable-audio=#{audio_options.join(",")}"
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
