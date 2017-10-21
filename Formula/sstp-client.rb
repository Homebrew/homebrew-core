class SstpClient < Formula
  desc "SSTP (Microsofts Remote Access Solution for PPP over SSL) client"
  homepage "https://sstp-client.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sstp-client/sstp-client/1.0.11/sstp-client-1.0.11.tar.gz"
  sha256 "1b851b504030ed5522ced431217a5c700b35e8bb72d6f5b40b006c7becb8fb20"
  revision 1

  bottle do
    sha256 "c9e1c4a81489bff6db3bfab2bb94bd5d5effd520794d1e034badebabe52b708d" => :high_sierra
    sha256 "1e635598256413113dabafeb7c29670c15ddef72ec7f838045c701beb360d12e" => :sierra
    sha256 "f26f09f558a834f4f63ccc8dafc551aca7776c64aefb166995dd24e37a14f325" => :el_capitan
    sha256 "696a8f7752dd97d1118b878710fc27c59a95fdc84bbc1f444dc91b9709d51351" => :yosemite
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
