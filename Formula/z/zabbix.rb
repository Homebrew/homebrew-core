class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/7.2/zabbix-7.2.6.tar.gz"
  sha256 "e8099cd909dc1bc1b3ec945f88686963877c3febcafc8a9ef54347fe563b9041"
  license "AGPL-3.0-only"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "29b4039e173f2b5f97aeb9e5786143ffa1ea79b3e03c389c683f1946857fd38b"
    sha256 arm64_sonoma:  "c5b7eaee62bc0fc3ed734f420faf66acfe95b286ca9fe387add3c3566b83377c"
    sha256 arm64_ventura: "6305ec1938e319698cd0ae71e1a7bac5b132c834a88a50f1ad7fc9ab08e07dfe"
    sha256 sonoma:        "95a4581f8551f9cf1e7209340838f78436af6976a95858150e25fc69a8d6af5c"
    sha256 ventura:       "7f6db18ff3cfe1d3dc7beddd6fbe9ad6c3ca92b456c04f63cdc13d5c433abd71"
    sha256 arm64_linux:   "ae83866143332e64f6dba01ba013cf4f2674f5fd6520c7993cc275e74068f05b"
    sha256 x86_64_linux:  "01c5449b5231042b445735ba1a63aa85b826c991173b0d146d16fc28192ef983"
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
