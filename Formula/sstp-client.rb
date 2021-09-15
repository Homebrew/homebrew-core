class SstpClient < Formula
  desc "SSTP (Microsofts Remote Access Solution for PPP over SSL) client"
  homepage "https://sstp-client.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sstp-client/sstp-client/sstp-client-1.0.15.tar.gz"
  sha256 "8484aa51fbfbe418a0ebad58ad20a8ee1c46ed71f800be18bcd23b42e6baad64"
  license "GPL-2.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    regex(%r{url=.*?/sstp-client[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_big_sur: "b4d5f320170ae3d03b27ee6aad79fedcc69dc74adcb7775dd284625515bf6d7b"
    sha256 big_sur:       "4456c0d7626d757558f3e5916fa2ec6dc5d0e16bd70dffbf1d9856c88f9f57ed"
    sha256 catalina:      "9d745ca078013a4a01009fd2e5d713d9c26e26097f3ca00878068ae8137cc516"
    sha256 mojave:        "1bc3a7e3a40676213301589608312b18298ce0f430c4d49fc0cc0ff18297d54c"
    sha256 x86_64_linux:  "0ab9094ef5d0a3c0e1b8936eef9d07d8e2adc460ff5a97e028402a944a4cf219"
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
