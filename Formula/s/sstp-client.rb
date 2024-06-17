class SstpClient < Formula
  desc "SSTP (Microsoft's Remote Access Solution for PPP over SSL) client"
  homepage "https://sstp-client.sourceforge.net/"
  url "https://gitlab.com/sstp-project/sstp-client/-/releases/1.0.19/downloads/dist-gzip/sstp-client-1.0.19.tar.gz"
  sha256 "f14647a58eaa5e6aa65e348225dd3331a11a28ecd2e8ce6234bce25c53144505"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://gitlab.com/sstp-project/sstp-client.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "2953f037ec852640b2b7d14354e8a9419b43141cd9809145d7a9eb14c99a3ced"
    sha256 arm64_ventura:  "ad03a3a56ce84af2eeb91380f6b5effbff184506e43959319604186a199e9c18"
    sha256 arm64_monterey: "5ceac69e2991116fe7ac5c77784aa296495fa15ace1885172a6752fb1f4b8029"
    sha256 sonoma:         "1ec6f61f44a78d8989b253f0c5880d99318326ddd46e745b6ab7c4b247cf30a8"
    sha256 ventura:        "f299f9f56b2d9a71172762a8fdfcff2af9b0398905329b25c9329c44088b9c16"
    sha256 monterey:       "e52800df6c7a1b575f7bc10bcb3977f0d494f553f3f77ec3cdac58713ddf20f0"
    sha256 x86_64_linux:   "7c50dd78ef394ec8eb4ec18347a3c13e529b3a01315be32a048a0da282488006"
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "openssl@3"

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
