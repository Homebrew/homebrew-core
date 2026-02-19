class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/7.4/zabbix-7.4.7.tar.gz"
  sha256 "16c39942feb283d7aea17e8271fcb4ffdbac0699156158dcb37219674f799bd8"
  license "AGPL-3.0-only"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "82fceed1592c9aaa592ab607eca3c87933679366f318afbf4d75d09df70c5593"
    sha256 arm64_sequoia: "7f8a72a1f185e0788e435c8ab75d98e65eac553ff324850f1c89a7cdc1493b2d"
    sha256 arm64_sonoma:  "328427e5d6a4c519259ffd804e5688e73d21d7daf28ac75c579935147cb80b63"
    sha256 sonoma:        "bcde1d5c12396c5912eda15be6d34879d7893264389caeb86f5f90e2ec808118"
    sha256 arm64_linux:   "c20a0e35baea66e0a305559886ecc582923d7b4162bbf24d4ae148be10db471e"
    sha256 x86_64_linux:  "d0f38d2d909614c8ea416394e06cbb73f891142704baebbc524c6959d87cce56"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "pcre2"

  def install
    args = %W[
      --enable-agent
      --enable-ipv6
      --with-libpcre2
      --sysconfdir=#{pkgetc}
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
    ]

    if OS.mac?
      sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path
      args << "--with-iconv=#{sdk}/usr"
    end

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"zabbix_agentd", "--print"
  end
end
