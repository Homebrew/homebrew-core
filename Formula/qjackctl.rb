class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://download.sourceforge.net/qjackctl/qjackctl-0.6.1.tar.gz"
  sha256 "dec2b1d98cc06bce6bc714a57521b15bafa2718835a1afffb6f0b1eb07d1c027"
  head "https://git.code.sf.net/p/qjackctl/code.git"

  bottle do
    sha256 "8c7bc53fa8a6ca3e7f3667f25c7a540c25caadb94954eab6a1db0d37c00adfac" => :catalina
    sha256 "f946cf13730aa5bd4e7acefbfaa2cdf548ed324c9b93291882b69c46c19b1bb4" => :mojave
    sha256 "adbc4f40b588fb096dc40923f1d37953a0424e70c2aa78ca375d1dd64751c52d" => :high_sierra
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
