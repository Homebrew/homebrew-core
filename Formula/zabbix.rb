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
    sha256 arm64_monterey: "87798ebc37ae6822d250c85949cfc6948d4eacdae9dd3c75af4db3a0663aae20"
    sha256 arm64_big_sur:  "bb495bde7366ab820b0ff7680008b84ed778c56f1236803805aa7b5876a42e76"
    sha256 monterey:       "e49e77fe8ab47b809b632b00966304f84775005405f25ad0dcfaa153f96a456c"
    sha256 big_sur:        "9c37b48445729832250f1320cce0c319e21b77a5d41da1830846c33336728899"
    sha256 catalina:       "36dc75884707ac2a4012fddae3122dce68cea6b3b5e04fd8c6ab9cfbd33e3d0e"
    sha256 x86_64_linux:   "87ff7a128248f218236b97b0ad1d611a1da7b54427570409f010022328682a64"
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
