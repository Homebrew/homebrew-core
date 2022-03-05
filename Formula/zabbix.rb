class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/6.0/zabbix-6.0.1.tar.gz"
  sha256 "2dd92383cc169ce8b8cbbe660ed656e5d6b5b75bf4936743b8a9d59cdfcf3af1"
  license "GPL-2.0-or-later"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "2efc79af9056617493577ab25993352cd15b4c4690ae8f36d28174d5516093d3"
    sha256 arm64_big_sur:  "7c93dc751146ecf7f5c4096a245265dd58c1487449fdd625a8dc779744bd9061"
    sha256 monterey:       "4a94b72a723256969b5b781452c1cf2ffa00321bd892ea4a2413daf690043715"
    sha256 big_sur:        "b02e1a23252dc45699904cd087e35f20caa77f7821a4f29bc85d764d1e035ed9"
    sha256 catalina:       "591db0838bb425f4c04d8af53d717981588659512fb088bd27e9e146e4325047"
    sha256 x86_64_linux:   "0ef2a057c75eced6194dd52e6cf607bb605e969ded59579ddac5535ce42bb85e"
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
