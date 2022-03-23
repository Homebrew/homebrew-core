class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/6.0/zabbix-6.0.2.tar.gz"
  sha256 "7ca89554bd998abcb9df819264293f7e222b4ef4a225acae3a9362d93c081411"
  license "GPL-2.0-or-later"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "6c1ab209fb2f309edf03d46a67c644e010377c7b1dd33fb9263fcf37be04789d"
    sha256 arm64_big_sur:  "41d847901fa5c4dc60fda36d1b9ec42a49dda23ac6cff42874bbfd24a5af5643"
    sha256 monterey:       "a9eb4186f2ffeaead860202729559f0908acf95466f3163cccb55c7d08f84ca9"
    sha256 big_sur:        "57600b85df1e8c44ce0ea1cffb82490c8ecc04cf31e2a39cf257875590fbfa6e"
    sha256 catalina:       "4c89f30a54967360e02fcf09c517d290bdd71bc6107756bd1bba5b9cfd7dcf5d"
    sha256 x86_64_linux:   "6e147b59679517e6843aa84a92aadbbdf8e772973b84e977ccbb894428ea3fe1"
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
