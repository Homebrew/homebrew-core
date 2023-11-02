class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/6.4/zabbix-6.4.8.tar.gz"
  sha256 "6daf750a3a5973e418f501b6ad1f3fee02341a8f15fd4a9a41c41923925f575f"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "15a8944e8ef13703d47f27d611cbaa8821c88f16f1bfb3b94e0bb8ddf721705b"
    sha256 arm64_ventura:  "1787925e3b4539325fd1a578003d2ea77819df9b78c0da2f4457a663a53c1173"
    sha256 arm64_monterey: "8f3b53e573cf34425cdc1067bcb18a2c066cfaaeae8c921afcc428c4b6b38118"
    sha256 sonoma:         "615edfa9bb16d9d2b07756cf352b5682f9cf56b82eeaa32355ab7588804fa9a8"
    sha256 ventura:        "93bfcb27568496425b7a6bf02d0b6ddda6f52445df0fd16b63aea56e57a7dcb2"
    sha256 monterey:       "02084f49706d6c2dd0d10f3f200c0cab1f5ce8082bf209b6feb9d7a9c6ed7edf"
    sha256 x86_64_linux:   "c03c0d47538aef7d5d79156cc664da30dd8b9d0866d49c5fb962762da97e431b"
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
