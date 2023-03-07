class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/6.4/zabbix-6.4.0.tar.gz"
  sha256 "b1c771da8799bf2802e176adcc1f00ee8083834bf8b8b2cc0323a437fe2c62ce"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "e2d86d35b30adb67738c00a81d7c8b4ad27353172d213ded67cb3dab75698070"
    sha256 arm64_monterey: "18cfa06031cd894f636b28cdd6606c3b965946fada9f33cccf0f4f465fa5f6d0"
    sha256 arm64_big_sur:  "c30c393971a91f1028469906be891ad0f444f15a0f24de56a8baa003dde9974e"
    sha256 ventura:        "e733bec3bc49f298a29e72b240648e5abc0ef37d805349b6d1522c4a4bc93f75"
    sha256 monterey:       "411b81f2ca498a75699dda516ba879524232c49c3429f7dde757ccdfcc7c0832"
    sha256 big_sur:        "afcdbc1d97cd00c5f5b7263f2c65d201c299cb31001f0baa6b89519ae1c0a720"
    sha256 x86_64_linux:   "77d492e6d4d9f4790bf6072396ab9b92fc9e0e323af223eceedbbb61ec8fd865"
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
