class Qjackctl < Formula
  desc "simple Qt application to control the JACK sound server daemon"
  homepage "http://qjackctl.sourceforge.net"
  head "http://git.code.sf.net/p/qjackctl/code", :using=>:git

  stable do
    url "https://downloads.sourceforge.net/qjackctl/qjackctl-0.4.2.tar.gz"
    sha256 "cf1c4aff22f8410feba9122e447b1e28c8fa2c71b12cfc0551755d351f9eaf5e"
    # fixes compile error with getDeviceUIDFromID and combo box device selection is general
    # also fixes linking without X11
    #
    # patch is composed of
    # https://sourceforge.net/p/qjackctl/code/ci/ce7bbc6814da9be44b9320fbe20dd524516d525f
    # https://sourceforge.net/p/qjackctl/code/ci/1983c9c4ce3ef663e29e8d07addee1d6856664fd
    # https://sourceforge.net/p/qjackctl/code/ci/979f0a5afef3107288b17a508966ca5f27ce7069
    patch :DATA
  end

  bottle do
    sha256 "5eb11af861de629ba8afba7d75c71b02029817a69d2a6a2db15f13fb3bea9594" => :el_capitan
    sha256 "5cf871c347c52298c161c83443f12a825cd18ce8037286dcc9cd552ab3857e9e" => :yosemite
    sha256 "671c6d52aa37729c4471390673310fa90c68139dae697f1630552b3b2511d690" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "qt5"
  depends_on "jack"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--enable-qt5",
                          "--disable-dbus",
                          "--disable-xunique",
                          "--prefix=#{prefix}"

    system "make", "install"
    prefix.install "#{bin}/qjackctl.app"
    bin.install_symlink "#{prefix}/qjackctl.app/Contents/MacOS/qjackctl"
  end

  test do
    assert_match /QjackCtl: \d+\.\b+/, shell_output("qjackctl --version 2>&1", 1)
  end
end

__END__
