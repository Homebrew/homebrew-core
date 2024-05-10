class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/6.4/zabbix-6.4.14.tar.gz"
  sha256 "044a4b8828882824f522269df48674fa08506212c7a8a624a0a592d898833841"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "62db4df57be36ff2d17468f13b18099715078316f957e3c0127ac455fdd140b5"
    sha256 arm64_ventura:  "9dc9efe61c2cdd0585212db14cb0f424bb8b37bebd5ad92b991e414a553614cb"
    sha256 arm64_monterey: "e62bb3b84d3dc8ef60af5c6b204fa9e1b2eb1966f3c516e31ba573a49737823b"
    sha256 sonoma:         "91ed84258e8d7e12b4910d466d273d57ee6cc0ef4519010ff7e8e519926f0391"
    sha256 ventura:        "9d0e93108c11d08fdd92d71b55b2ec4d1eaf41e6c58b7b86ce9f0f50f1c2105c"
    sha256 monterey:       "27738a5cf1dcc8650831cc430a0d9cb659e9eab3f6e604f3c8aa7c810808b861"
    sha256 x86_64_linux:   "eb9ab141eeda1c4876b857f9909297fc7f948467f07a0283b7dea41abed30823"
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
