class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/6.2/zabbix-6.2.7.tar.gz"
  sha256 "6d423810667b948ed22052d9aa84a035e2d4b92cbe8efdb669cac529806b722d"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "bbfd7dd36775f0db83c2019555e373808fd46337ef1230d9ed8b63708f95b9d7"
    sha256 arm64_monterey: "9a3a919725a5a1404b54e77a46eda545dbc3118832f7eb6a864900d3ab0b7911"
    sha256 arm64_big_sur:  "0922e0110812b49d4cf153d33f9f616e28d5a3e4ea80537e4f0d9b72a6722fde"
    sha256 ventura:        "fe8d39f3ebf3ad3a5a7f0b0ad7a1afd8fdebb93518b3acff3865349028d66031"
    sha256 monterey:       "fbe767594a19e13e098be2c789d34558b66e006ff1d937fac21f1898e7032a6a"
    sha256 big_sur:        "bed92c66991ce6fff8c9ea7e8d8f3067930430fffadefd517f50e325fa042a0b"
    sha256 x86_64_linux:   "b600259cfb22f02b7b843692bd480219c8b43c0d1eee900d4c73859c6c752cec"
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
