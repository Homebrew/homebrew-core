class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qjackctl/qjackctl/0.9.1/qjackctl-0.9.1.tar.gz"
  sha256 "4fbe4c98ec5ce45efdd6a1088e2f5b208f5bcce994a8697b0bc96ecee99be254"
  license "GPL-2.0-or-later"
  head "https://git.code.sf.net/p/qjackctl/code.git"

  livecheck do
    url :stable
    regex(%r{url=.*?/qjackctl[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 big_sur:  "27f1483fa8d07de09612aa321728bddc11cd67fabb16ec19ee95aac1a1e037b6"
    sha256 catalina: "93a7cc8b1101d27345e0a35c198453178c8a7384d43fb22303117acff8fec90c"
    sha256 mojave:   "369a21fffa390380d0b9d3c16507c4626436d0367a7bbc073c0ec4eb0689dad7"
  end

  depends_on "pkg-config" => :build
  depends_on "jack"
  depends_on "qt"

  def install
    ENV.cxx11
    system "./configure", "--disable-debug",
                          "--disable-dbus",
                          "--disable-portaudio",
                          "--disable-xunique",
                          "--prefix=#{prefix}",
                          "--with-jack=#{Formula["jack"].opt_prefix}",
                          "--with-qt=#{Formula["qt"].opt_prefix}"

    system "make", "install"
    prefix.install bin/"qjackctl.app"
    bin.install_symlink prefix/"qjackctl.app/Contents/MacOS/qjackctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qjackctl --version 2>&1", 1)
  end
end
