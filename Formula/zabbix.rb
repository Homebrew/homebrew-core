class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/6.2/zabbix-6.2.4.tar.gz"
  sha256 "e2526603d9b487a26046de3022e1722b66f4b25542886b3e40a8e2b3bbdbd3b5"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "7b4ca8391ae3ea15ac178843d167922ffcdf567f72825c2e9612bda9cc058a87"
    sha256 arm64_monterey: "31616bd3d19f7f9866d146724c97757c3e768a78374471da5c7d025fb7b60329"
    sha256 arm64_big_sur:  "5b8ed15da286b95e8b83d52f8d1ef947ad92ae23bc2d11ac9066c3835727ece6"
    sha256 ventura:        "4a1a6e0ea7a19624c6989e2d46f08f197831fba9747936034044c824d9512bec"
    sha256 monterey:       "8b2724da5f21bae7b5400c9aabc0f018f78950d199305eb836178985f98fda23"
    sha256 big_sur:        "fc528e4c943724d7ddccfb3d2de7b57c3c303b6f5610477c4a4cf3cdbb195d7c"
    sha256 catalina:       "2ff7853bd02ecfe32493c40006a97c9db7c355b1b7925752f8aa83b3f93961b5"
    sha256 x86_64_linux:   "30f466b4083b8a3484131500f37e70e6779f610d3efb9f2a32336c44364854a4"
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
