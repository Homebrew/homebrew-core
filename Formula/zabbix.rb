class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/6.4/zabbix-6.4.3.tar.gz"
  sha256 "7747461f83db46399e0aba9bd92f541a865f8a5c80dedd4ad3be378b843c46d2"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "0a2140c2c3537b2106fc28d5c5eb464509eff1dfb13bc6b54d8e725ca0bf4bd6"
    sha256 arm64_monterey: "ac09234b6872a8069db82d9c76d4018bb7327b032c9d642e51ea6c5bdc7ee4a7"
    sha256 arm64_big_sur:  "aad01aec6d329ac5993f57e95a4b7e2a1e025a5df8928b4371f8afaf77ce71ad"
    sha256 ventura:        "6bad8751162c6bf748d61851926079b7cdfc2a5b02e3f82c7c69c094138023d9"
    sha256 monterey:       "29e610adb58b016e58192ffc82540daea5ac72a9ff6a62445d97146121e53f1d"
    sha256 big_sur:        "323cf0c184109494845b42b55a27d5798d12bd71b66ec4b451a6642e5a65878f"
    sha256 x86_64_linux:   "4f86f77bd566327c069a3e7e0896c4fbe0c5a9cebfdde64cb846ee5f7e9577cc"
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
