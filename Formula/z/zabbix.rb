class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/7.0/zabbix-7.0.4.tar.gz"
  sha256 "06fdb4d70a8a1fd2012ed01f84d0562a94a46163719f21cb11cb4116b6ffb5c2"
  license "AGPL-3.0-only"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "20b5924a3f4eec8a1f9eafdd459f6b7198586434b1d64b191c2022d774ae48a1"
    sha256 arm64_sonoma:  "0fdf1fc44b067082fe5bf0f7df3a703a7be2bdfaac0695b99746508a977e65cf"
    sha256 arm64_ventura: "3f601e9a20984d1919d55ed14998ecbe678c7150379c3b72e29b4275614ca521"
    sha256 sonoma:        "086326103709a6c3eb340aa374ef5fc81b38481c6a0fb9f22ae8a16f1c972a25"
    sha256 ventura:       "c146f602125ac121162029a259f694fac4560912a0e547d3af98d443a6249f89"
    sha256 x86_64_linux:  "4b79b6130b1f79994d08117e5722023d6de15ff47ce44f94755d5ca06bad377a"
  end

  depends_on "pkg-config" => :build
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
