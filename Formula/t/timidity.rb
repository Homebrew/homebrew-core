class Timidity < Formula
  desc "Software synthesizer"
  homepage "https://timidity.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/timidity/TiMidity++/TiMidity++-2.15.0/TiMidity++-2.15.0.tar.bz2"
  sha256 "161fc0395af16b51f7117ad007c3e434c825a308fa29ad44b626ee8f9bb1c8f5"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url :stable
    regex(%r{url=.*?/TiMidity%2B%2B[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "d1870a696de648a1ed46e25d590b6f6a3bfa73091044c8623fbf77901e71c7a9"
    sha256 arm64_sequoia: "8e504bb7f36e5feae11358a05aaa0b9651b84cc60664d4d8199c6c72c07d13c4"
    sha256 arm64_sonoma:  "faa51ccbf4324d22f47660879db054f204dd19fd7d18361a4e8bc207b261ae10"
    sha256 arm64_ventura: "ae1cb080608f21a9265afd6faa3ce8a045a69ef72347306661580adad6da2d4a"
    sha256 sonoma:        "e64e294d42736c8781c217604b149e2bbc03754312416f92b3bae9a6e2ecde54"
    sha256 ventura:       "8547254f49bc780399c907f8a23916843840065a06ebdfce850b0a3280429b2d"
    sha256 arm64_linux:   "4c6b979e2ec599528a1fa01884d6886e757ccfb57624785b27f3ca2c4bf6167c"
    sha256 x86_64_linux:  "641143b8f2f77b6d9c41cf16994b389cfd2523ec4f97d6bd1acabca4a5f376d1"
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
    url "https://github.com/feross/freepats/archive/refs/tags/v1.0.3.tar.gz"
    sha256 "d79fa8719500880627b1b65286fde6ddb06274540a3eba21178d2058d525007e"
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

    # Freepats instrument patches from https://github.com/feross/freepats
    (share/"freepats").install resource("freepats")
    pkgshare.install_symlink share/"freepats/Tone_000",
                             share/"freepats/Drum_000",
                             share/"freepats/freepats.cfg" => "timidity.cfg"
  end

  test do
    system bin/"timidity"
  end
end
