class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qjackctl/qjackctl/0.9.0/qjackctl-0.9.0.tar.gz"
  sha256 "5196c5c01b7948c1a8ca37cd3198a7f0fe095a99a34a67086abd3466855b4abd"
  license "GPL-2.0-or-later"
  head "https://git.code.sf.net/p/qjackctl/code.git"

  livecheck do
    url :stable
    regex(%r{url=.*?/qjackctl[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "2b1d7e384d27c5a4a0efebeaf17c4d537bd0b54e3a559858974fc202e2bc74eb" => :big_sur
    sha256 "5a5eebb3680306820a64891b9eaf06fdb9fc0f7769ed7f870fd682ab41de718e" => :catalina
    sha256 "96b34130264ef5bd30bd1c8cc4ac4bb149041df187daacf6fa687f5221bdb103" => :mojave
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
