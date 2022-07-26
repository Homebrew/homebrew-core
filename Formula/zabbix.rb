class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/6.2/zabbix-6.2.1.tar.gz"
  sha256 "f3d6b7cf4e67d820ce7d28cd54ac67724f7453f261f668877e6410cd21ab9ea1"
  license "GPL-2.0-or-later"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "07329826a13b7bc4624a3124f7cf79f9c993f68bafd94b4e3ab08e56ca702f4a"
    sha256 arm64_big_sur:  "8938f8713ab74361153134623b3d0862acfeb3ada4a4cf9602ad81fa4b9f4459"
    sha256 monterey:       "7d7022a283c49a1014be73d93c436c9ec8f11d217154e25d9c86bcd70b91a8c5"
    sha256 big_sur:        "fedd929e227423c95433a5aab124272b2bdca74aadd52287650909e08eb1741c"
    sha256 catalina:       "cf189371c9c7b827f428102baea7ef56df13db80c70e9566c749b1b6d0caf135"
    sha256 x86_64_linux:   "2a45161f61f70e8b6e7c3f8ef88032a619bade9ec8d1a69a779629efcaff2947"
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
