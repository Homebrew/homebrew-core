class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/6.4/zabbix-6.4.1.tar.gz"
  sha256 "331e5de1a6856de285d9aa0d26c310aaf6d2fda9064397bd913d1c4bb767f8c0"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "8e481a6e7d8d5beeecb45180bf9e4a8d547d4392040fffaf2643495adab2fd57"
    sha256 arm64_monterey: "c5c105e3f0593e22564a2bfecb37d1b1fadd7d14747bcc3a977476159bf10af2"
    sha256 arm64_big_sur:  "e32f3844d4541bd613e00e080d1e66502ecfdfaec106e890414d7583211b73b4"
    sha256 ventura:        "b86edd2e377f707836f701ec45c8488f65ed954b6c6ccbc69466f99a18487a0f"
    sha256 monterey:       "a732f42fa35c963fce85e5b612ec2617b55b278ed08a55214f2be15e76c383bd"
    sha256 big_sur:        "54f2df91efa22d076af3fe9c6ce049bd5ac2c3ff7f23106dd5edcbbdc0e3f8a4"
    sha256 x86_64_linux:   "6e48a151d1f213f2af43f8c2ef7be94ba8b6416a470a93666e1f67cefba11bb4"
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
