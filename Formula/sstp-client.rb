class SstpClient < Formula
  desc "SSTP (Microsofts Remote Access Solution for PPP over SSL) client"
  homepage "https://sstp-client.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sstp-client/sstp-client/sstp-client-1.0.17.tar.gz"
  sha256 "29dd3b9c7111ad6983cd663d5a2f069e1f8a95a913aabc8e166970146657925d"
  license "GPL-2.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    regex(%r{url=.*?/sstp-client[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "e7dfb4c56f6cc45caef7dc6d6f5085fde600d9445210d587100af343dcfadd40"
    sha256 arm64_big_sur:  "15d0080ab4e9c17f22e55e4a6f8052a744f48da915d65c4b4ebf2a987fb3cb3f"
    sha256 monterey:       "2903e65cbbce634d2690f5afd0c71a78e825512cba57b8649032a2803380defc"
    sha256 big_sur:        "f21af6377f3cd38f2b35f7eead926529923d1f8698418dd701d2b562f4061809"
    sha256 catalina:       "35bd18ae8379994f7753b535a1e7401aff2c13cf2b57a918b5ef0453ab8ce1e8"
    sha256 x86_64_linux:   "304de66a26177df61bb21594741c877b8c3d65b7f3b0a44759eafb90d8ea0b64"
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
