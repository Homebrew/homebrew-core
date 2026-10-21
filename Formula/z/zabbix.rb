class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/7.4/zabbix-7.4.16.tar.gz"
  sha256 "0e2c391dc184acce8e34250e7326a51e19c8bcee31e67b8497f5526247ecd261"
  license "AGPL-3.0-only"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "f217a63b2810ed08189873139cd5398f1046a0028a2540000e40eeb70162b8c5"
    sha256 arm64_tahoe:       "60dddddb0ac6044090083220e396e7721de1229deeb6bc61e8656d757a493665"
    sha256 arm64_sequoia:     "0d875be06a8b6dc7d2c57412371641a5886d9c0ec8930a2c147c3a4dd708add8"
    sha256 arm64_linux:       "cab3df81bdeebcb4324c9100ba4dcb5b21ebb75ea865b81a68b4bee57899feb1"
    sha256 x86_64_linux:      "78ff7a0c2f49bb6e5ef9e85439a99b647e2d190d882a27b18d4b374c3407ae5a"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@4"
  depends_on "pcre2"

  deny_network_access!

  def install
    args = %W[
      --enable-agent
      --enable-ipv6
      --with-libpcre2
      --sysconfdir=#{pkgetc}
      --with-openssl=#{formula_opt_prefix("openssl@4")}
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
