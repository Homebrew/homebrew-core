class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/5.4/zabbix-5.4.10.tar.gz"
  sha256 "462b1c7506f22545916a8c6ffc50c297c952e21125a9240dedcf858070e59877"
  license "GPL-2.0-or-later"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "7b2a4a6b8b76a05c3715fb97fd63880015372da3f706d5486299e8c141e580d4"
    sha256 arm64_big_sur:  "e6243079ba8cc2e8b897472b12d9487cf7358e6e355d862ceed1420b5bb9434c"
    sha256 monterey:       "bd9ddfee43eaa57a4a0a9f774423d6ca862010d644b89d35934b771ed97934dd"
    sha256 big_sur:        "4030456db52f5c1b30ad5a0ff036c82af008e23683d444df80feef1125c7a75c"
    sha256 catalina:       "c074d5aee35a3695245b0e85907488f2a91218a7f10754815d24342386933ea3"
    sha256 x86_64_linux:   "f6c4d0316876e8123da73c418390e30c8dfef6d23dc1f3aca74cb4c1a63637fb"
  end

  depends_on "openssl@1.1"
  depends_on "pcre"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}/zabbix
      --enable-agent
      --with-libpcre=#{Formula["pcre"].opt_prefix}
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
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
