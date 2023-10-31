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
    sha256 arm64_sonoma:   "d16638cdb1dc6a5c43dff3e6ca4521ce420de54406b86c78ebc938728555b207"
    sha256 arm64_ventura:  "50a5b6bd5a36abd9cd2fab4cf6ab185663196f6d1efe99890c1fad16492c8f75"
    sha256 arm64_monterey: "e994dc8c290c727cff1563a668a8a84cc719359ef85b2effef27af33b6c64269"
    sha256 sonoma:         "c3b408c7e9d65b985870a4d06dd82fcaca0f96403bce1838dbef9f080dba149f"
    sha256 ventura:        "9d4d741cc312367870a9f40ee4af6db418470477b9107b5e577c3d6a92202ab1"
    sha256 monterey:       "de845b6ed584f4739ef96b1d43f1133c812d659273913e852c0cc42d9c7e10c7"
    sha256 x86_64_linux:   "2ecdb25cbfbe9f593feec7f831399c879f261a59352243cea60b734f0ca3822e"
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
