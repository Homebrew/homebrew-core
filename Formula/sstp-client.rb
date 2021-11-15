class SstpClient < Formula
  desc "SSTP (Microsofts Remote Access Solution for PPP over SSL) client"
  homepage "https://sstp-client.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sstp-client/sstp-client/sstp-client-1.0.16.tar.gz"
  sha256 "afbe14fd122f7875f4fad0ed982d1745136d2e66cc36b97f72ef1a1111784ca1"
  license "GPL-2.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    regex(%r{url=.*?/sstp-client[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "9c2534376bf7be0a4dc2b97e1c1e5d405cc90da83ad92fe2871c9105c35c80c1"
    sha256 arm64_big_sur:  "5e5c49ec6d39cefd38fe35b79e8001229a5584c7c557de7841b05d073bd60551"
    sha256 monterey:       "41dd31f2d678981386c71bb7115a32271da3955d0d8dc2d5de02193d689c0517"
    sha256 big_sur:        "9e5ce6c84a04375105fdfb9c69361f305b4b33d6118be628ec44a80afddae6f8"
    sha256 catalina:       "fc29ac3c9ec3966a0ffbe198263dff3d8e1da078e168559f8b1c326c7f0320c4"
    sha256 mojave:         "d1f974075c7dc0ed51e35fceffa91cf86a762ed6627f5ad692a9c9df6cc543bb"
    sha256 x86_64_linux:   "a689802f48ff92cd8c4cabdd8b61185ecceb5bedbc225433eed4be8841774519"
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
