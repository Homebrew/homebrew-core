class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/7.4/zabbix-7.4.10.tar.gz"
  sha256 "8557600b93666f2f89b108e9998977740e08ec35f2a025da30b760822e966bfa"
  license "AGPL-3.0-only"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "d3107ca9d7be13e7eea9930ec6532b1606b42d1760f4ec34bdc51a373fa0c3c4"
    sha256 arm64_sequoia: "bd288ed00a7c66de0440d38af7a9a262b6524d6a776aad3be0b376d5ac2cf252"
    sha256 arm64_sonoma:  "3dd3356cf15ae3cb48784423275eae2ad2d68cc46eef85a5b49213ac0b3f33aa"
    sha256 sonoma:        "2aefb0b8fa56e4f5f56c0d4c2574564d193afe8538452319652aa19b641f6f73"
    sha256 arm64_linux:   "a18a07e3cdd94ff6ee2cecad23e7f3277f139e0695753cc6a9dda026ad663504"
    sha256 x86_64_linux:  "62b3e47629f5e4ba5ee78d2c9b20debbebb0837d07cb0a363537a7da93f8fbf4"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "pcre2"

  def install
    args = %W[
      --enable-agent
      --enable-ipv6
      --with-libpcre2
      --sysconfdir=#{pkgetc}
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
    ]

    if OS.mac?
      sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path
      args << "--with-iconv=#{sdk}/usr"
    end

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"zabbix_agentd", "--print"
  end
end
