class Timidity < Formula
  desc "Software synthesizer"
  homepage "https://timidity.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/timidity/TiMidity++/TiMidity++-2.15.0/TiMidity++-2.15.0.tar.bz2"
  sha256 "161fc0395af16b51f7117ad007c3e434c825a308fa29ad44b626ee8f9bb1c8f5"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/TiMidity%2B%2B[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia:  "192d64a9d4bd9425e399baacb67512c94fc60f52ee81016ed71afd9482ea5c47"
    sha256 arm64_sonoma:   "4c35935f5ab6bef4f133601dcee29c8f992dc4ceaa35541d4a881dd414b128fd"
    sha256 arm64_ventura:  "733c42a66bbbef0581bfffd17818184d7739f7388284f8aa8474d590e2fb023e"
    sha256 arm64_monterey: "d471c899e61b20c831429a9e98b9e2980c182438c2ebd4eb4b5e6c4760fe725b"
    sha256 sonoma:         "4d3ffe2f9725898d435fec7e619d0f396cfa3b053801d7f9f16a5e7eafce3051"
    sha256 ventura:        "eaefc53812370a3675964745649ecc49e524d37a8c576d3331c857b52148572a"
    sha256 monterey:       "b94b23e9e855b931f7ae2604e2e8030e10d049af93c101a7aa9d39d1208ec553"
    sha256 x86_64_linux:   "eb933705b211fb7f7f2caa7e514f7055bde34c9d911aba8a35e43b63fe1579d8"
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
    ENV.append_to_cflags "-DSTDC_HEADERS" if OS.mac?
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
    system bin/"timidity"
  end
end
