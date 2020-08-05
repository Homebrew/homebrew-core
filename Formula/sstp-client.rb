class SstpClient < Formula
  desc "SSTP (Microsofts Remote Access Solution for PPP over SSL) client"
  homepage "https://sstp-client.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sstp-client/sstp-client/sstp-client-1.0.13.tar.gz"
  sha256 "961258fca0795d8ad60b047942cf7cb53d025d353fd1e4ba08c2b75799f5321b"

  bottle do
    sha256 "07d9e21c21591a675d760f059838f26bbbe02a04b27518bce5d3a9b0d0069194" => :catalina
    sha256 "0c32039442cbe0c26bc90660fd99e19940b71677637b60d03350a4c90b3ca35c" => :mojave
    sha256 "cfc794cfd038b84da0b1f329bc7eb6f5c5165e1727ec53c259a5d93ab48d47b0" => :high_sierra
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

  def caveats
    <<~EOS
      sstpc reads PPP configuration options from /etc/ppp/options. If this file
      does not exist yet, type the following command to create it:

      sudo touch /etc/ppp/options
    EOS
  end

  test do
    system "#{sbin}/sstpc", "--version"
  end
end
