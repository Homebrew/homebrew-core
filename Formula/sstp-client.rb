class SstpClient < Formula
  desc "SSTP (Microsofts Remote Access Solution for PPP over SSL) client"
  homepage "https://sstp-client.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sstp-client/sstp-client/sstp-client-1.0.12.tar.gz"
  sha256 "487eb406579689803ce0397f6102b18641e4572ac7bc9b9e5f3027c84dcf67ff"
  revision 2

  bottle do
    sha256 "49bffeb675814b187dd9237be82ef24e45d92f99b162d86dbbc07191f3817094" => :catalina
    sha256 "ae3fd0084d4a41d7e61cdd50c63049e401aa2d6a29f17c1d5b60b2693c3f42cd" => :mojave
    sha256 "a01dc2761f3a46199b4499650fda972c98f91ec4f4a4f91273a354e73592ca8e" => :high_sierra
    sha256 "bee90ce7dd97505c82ec1e159134a3ac73065dbe8257c839f9ec0b5d33271640" => :sierra
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
