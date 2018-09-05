class SstpClient < Formula
  desc "SSTP (Microsofts Remote Access Solution for PPP over SSL) client"
  homepage "https://sstp-client.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sstp-client/sstp-client/sstp-client-1.0.12.tar.gz"
  sha256 "487eb406579689803ce0397f6102b18641e4572ac7bc9b9e5f3027c84dcf67ff"

  bottle do
    sha256 "361a2e8e315b16b5444338c13e11db2d0b78bb8ad0f73de18526d164f87b237e" => :mojave
    sha256 "f910157864b32a5cd004366b0e8ee6cefd09b0edd36afb89d751ede34e27df96" => :high_sierra
    sha256 "1bbbe9f5558b4757f8244064144106b0bda636c2adcc3da734634895b960ff68" => :sierra
    sha256 "c4b0b6b1ebc16783d22327173bfe1e90bd5fd329786a613422c858fc352672eb" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "openssl"

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
