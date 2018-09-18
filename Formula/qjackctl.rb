class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/qjackctl/qjackctl-0.5.3.tar.gz"
  sha256 "813be3b92442ee89a1894407980cb3c95b549e6e94b6b155f218d15291530874"
  head "https://git.code.sf.net/p/qjackctl/code.git"

  bottle do
    sha256 "e661c47a8bb9be298dabc9d0c656f962b7157c6aa7dcebef18119af8ea07c26b" => :mojave
    sha256 "e23c9278a737692dffba9f15d4ba96ee3545d5054d4dc40b8f298fa2ac88d6d0" => :high_sierra
    sha256 "b5561ee222cd865048a52ea95c98f1a06b05d17ed31500a8f7e8407ef8caace2" => :sierra
    sha256 "8c0022b1933f24a53f54ca478a51231951efb00bfbe7f54f68645b5559a551e1" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "jack"
  depends_on "qt"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-debug",
                          "--disable-dbus",
                          "--disable-portaudio",
                          "--disable-xunique",
                          "--prefix=#{prefix}",
                          "--with-jack=#{Formula["jack"].opt_prefix}",
                          "--with-qt5=#{Formula["qt"].opt_prefix}"

    system "make", "install"
    prefix.install bin/"qjackctl.app"
    bin.install_symlink prefix/"qjackctl.app/Contents/MacOS/qjackctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qjackctl --version 2>&1", 1)
  end
end
