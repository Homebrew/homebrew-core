class SstpClient < Formula
  desc "SSTP (Microsofts Remote Access Solution for PPP over SSL) client"
  homepage "http://sstp-client.sourceforge.net"
  url "https://downloads.sourceforge.net/project/sstp-client/sstp-client/1.0.11/sstp-client-1.0.11.tar.gz"
  sha256 "1b851b504030ed5522ced431217a5c700b35e8bb72d6f5b40b006c7becb8fb20"

  bottle do
    sha256 "1fc1e56346f4cb8f35effd7986e22a13f9f2236448c44f479a8118f5600e6bc1" => :sierra
    sha256 "f3c353fbd733524d34ef2448c30e3064391ed4b13b4e0181fee825912a9c3977" => :el_capitan
    sha256 "faeff7f1d82cafa3e463451e38320fcc9461d24b1122a0cbcc4f2e2b93b3876f" => :yosemite
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

  def caveats; <<-EOS.undent
    sstpc reads PPP configuration options from /etc/ppp/options. If this file
    does not exist yet, type the following command to create it:

    sudo touch /etc/ppp/options
    EOS
  end

  test do
    system "#{sbin}/sstpc", "--version"
  end
end
