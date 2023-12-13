class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/6.4/zabbix-6.4.10.tar.gz"
  sha256 "dabad1af52ec5f3b65ca3d5001e5782cd731d104394a7183bd81dfae5d6abd25"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "19d7e35b0f20a9f577a608a3e752d55af8eb406111154fc4df692eb40ccb3221"
    sha256 arm64_ventura:  "20cd3ac555b91de6108d1edb2187ade7a02eff252a360ce1788f01bd22cb3b61"
    sha256 arm64_monterey: "e6a490df95393c8f054c3d0b05471c2afc096d394f68fd1d8bee00ec359008d6"
    sha256 sonoma:         "190a4b1cade8d7e995da4b1ba589dffb5736dcf6790b097059e650019f1d1bfd"
    sha256 ventura:        "299717a5760c63ce0f1150ec24b40f8d97d23b252b27941ddb0c079be3ac29ff"
    sha256 monterey:       "7044a5f9f775decca8a7829f8d4bbe97a601ed7787b0902b86cc81bfc844a22b"
    sha256 x86_64_linux:   "c272c7032f20d4484f61865c044118f77bf1de2343218b1983f00a68d6260881"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "pcre2"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}/zabbix
      --enable-agent
      --with-libpcre2
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
    ]

    if OS.mac?
      sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path
      args << "--with-iconv=#{sdk}/usr"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system sbin/"zabbix_agentd", "--print"
  end
end
