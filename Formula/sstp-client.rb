class SstpClient < Formula
  desc "SSTP (Microsofts Remote Access Solution for PPP over SSL) client"
  homepage "https://sstp-client.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sstp-client/sstp-client/sstp-client-1.0.12.tar.gz"
  sha256 "487eb406579689803ce0397f6102b18641e4572ac7bc9b9e5f3027c84dcf67ff"
  revision 2

  bottle do
    sha256 "7999babf31a04719940d1c54c4ab4275b15963ef997a29b5f0e867246b778eb6" => :mojave
    sha256 "ddc52b9c61688c727dd3a44fce16c9c5cbc99ab0e2d029421457c9f2f5a91e0e" => :high_sierra
    sha256 "53e794c8990933a514c95ec3fb8bab4164c8027e2dfc5dbd23a356fdaf3dfa44" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-ppp-plugin",
                          "--prefix=#{prefix}",
                          "--with-runtime-dir=#{var}/run/sstpc"
    system "make", "install"

    # Create a directory needed by sstpc for privilege separation
    (var/"run/sstpc").mkpath
  end

  def caveats; <<~EOS
    sstpc reads PPP configuration options from /etc/ppp/options. If this file
    does not exist yet, type the following command to create it:

    sudo touch /etc/ppp/options
  EOS
  end

  test do
    system "#{sbin}/sstpc", "--version"
  end
end
