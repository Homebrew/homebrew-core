class Remctl < Formula
  desc "Client/server application for remote execution of tasks"
  homepage "https://www.eyrie.org/~eagle/software/remctl/"
  url "https://archives.eyrie.org/software/kerberos/remctl-3.15.tar.xz"
  sha256 "873c9fbba51ff721acb666e927f58f4407f08eb79f53b5a058801f5f404f4db2"

  bottle do
    sha256 "f2497816a9b4f36e804de521937b994292369f2c28099430cbc81e00ecfd8f45" => :mojave
    sha256 "699be918b80d41c46ec8aabb4e04219123fec8beb60f1169c33b8a14ef7e24c1" => :high_sierra
    sha256 "3dfefe916442dcae4f049f56673ce735ee84b931423b184f4d7fab770d7a5f39" => :sierra
    sha256 "301065db3a4020b2237268eee8709a639d33dac24b21a3294641f7d9beef0ab0" => :el_capitan
  end

  depends_on "libevent"
  depends_on "pcre"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-pcre=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end

  test do
    system "#{bin}/remctl", "-v"
  end
end
