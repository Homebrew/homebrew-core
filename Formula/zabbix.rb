class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/6.0/zabbix-6.0.4.tar.gz"
  sha256 "5743b6cc2e29d9bd242aa88b2835f3ded0be177509000d84db74e1159c5afa75"
  license "GPL-2.0-or-later"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "d9e57fac7e26b546f7475bf52dc7384744fe12d5483c576038240c5f06d376e4"
    sha256 arm64_big_sur:  "fd9d418501cef8fda973942ea792e7475aaceb3f9aa564a9f643537938dd96aa"
    sha256 monterey:       "95e8b14c4fea6f8da5fb57df457d7a1dd6b0e0d63b95a568e19684ac96bb50cf"
    sha256 big_sur:        "ae88bb4ff58258fc050647c1655a6d577dabfa265101e0ffae5f7856b5fe65e0"
    sha256 catalina:       "35ea17458ffe3f993e488902029092a67b32f7a9e70759151ed4d44d00a1c8d4"
    sha256 x86_64_linux:   "dc5f1232cf3403a78ee6ad3995d17ced5d17f65749d28fcf72aa10578843a7b8"
  end

  depends_on "openssl@1.1"
  depends_on "pcre2"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}/zabbix
      --enable-agent
      --with-libpcre2
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
