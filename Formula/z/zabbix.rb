class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/6.4/zabbix-6.4.6.tar.gz"
  sha256 "4e432f8a87d8a6cfa3366457c4165c3c6b045b03b781c46eac17cf96c98bb933"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "d0b3f3c1b294e9f18e9eae604e5f0f8a41b2562e1e281528483f87fde5de3639"
    sha256 arm64_monterey: "f1e330f62084cdd0a747f377c50c6f6891c9d8bb87b6734b11addc53cfdcec6b"
    sha256 arm64_big_sur:  "c0fb1a45331262b4c334ae0bf220bcc65500767ae12469e1723b187b891f26a3"
    sha256 ventura:        "b0ae12e20bbf686252b8023f2aef94d8e41eb46fd977f5821b458158dfc1877e"
    sha256 monterey:       "147b3ecbceb0aafda0268a8eb374148ff515554558994b9fbc295c0f972864e5"
    sha256 big_sur:        "f5b4f08de25a73efb90feec364515f9cf92ea4eecefcfdb6cc02d526a325892f"
    sha256 x86_64_linux:   "b7d32d54f9ce783f6c4592ab08f8e138b7fff4a8f9d4a66f7c5ced34a5d93acc"
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
