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
    sha256 arm64_ventura:  "4380e86b0730765ee38030efe029341d6bd0168ce34e986c38914f4db642c899"
    sha256 arm64_monterey: "0b3046ba19b0f69350fe71399e1154b6396947f0fd4b95a3dd6de9c000c4fee3"
    sha256 arm64_big_sur:  "99e4ec75154c986c6e0081283e79f61d00baa17d6af4c7f0f74edd7194e48ad6"
    sha256 ventura:        "62d3cff9cfef3977eed5ff1eec6571816a106e5cb3d733305c1a4c1a141781b9"
    sha256 monterey:       "39fe0d8a8dc9fecb84ab2df20fde6596cabdb5e75bbe7d34d8b2bebad0b545e3"
    sha256 big_sur:        "42b3fbf3384025c010825aeec65426e8dc7046844f2b859a80adaa1c91641787"
    sha256 x86_64_linux:   "a3d370aeeb7349719fa3da99afda5beba968dbff87b8ec6bb4dcc16c1300607c"
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
