class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/7.4/zabbix-7.4.9.tar.gz"
  sha256 "f97ed8932821a51f645100adf7d480e87580eb4e83849c104f44fd556af1afcf"
  license "AGPL-3.0-only"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "02bca0f065e01f8238d043d7ec058d92f045204801ca77f3c4f3b538a639446d"
    sha256 arm64_sequoia: "52fee2b500cd0dd1244b71d214db80bfe4b366fd54cb0e5c45dee9741974b054"
    sha256 arm64_sonoma:  "0ca9d94f5176b4c66afb0d6988bcdcf821b5fa833023e429b6fc732203d278f6"
    sha256 sonoma:        "2336df6afb321d45a71a017346e8f199570fefdde34636a984d5f0f504239dc0"
    sha256 arm64_linux:   "31d381b360ec9dafd3a319729cc4683a5a7dc330e25060a1084d18ff4eecf568"
    sha256 x86_64_linux:  "57e2546ece8066219dec70561de5cdbc7345d72939961c6e6b4ee7a16f5d8afc"
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
