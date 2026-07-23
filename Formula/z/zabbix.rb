class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/7.4/zabbix-7.4.12.tar.gz"
  sha256 "2c60629e5dce61f503026c99d8a92c2f66ade32eefd898ba5d9000fde9eb9dd0"
  license "AGPL-3.0-only"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e6583177116159161a028c6e6610f6f349b2938d317c8056135849e5a9e85c57"
    sha256 arm64_sequoia: "433d836a8f33c595a4cf766c3b5239dbb9f3e38b2c71abb64610a165a6efb1d2"
    sha256 arm64_sonoma:  "a400327bf57c44a134c6e69f827664602e72d7b3bc1e790b57edd127446b2f1b"
    sha256 sonoma:        "042599f1beba975fb7d7b54e57966f38e28996994c2178d4e9b7acde61304f7d"
    sha256 arm64_linux:   "7c3ef6c091778046ab7ee00bc28f39a1a171fceb962f22f1fc931e5917e8e1e5"
    sha256 x86_64_linux:  "f4d5dcec7d3b8aa80106c7a88a76ed60e79363c871fa464c5cbcd6e56c23678c"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@4"
  depends_on "pcre2"

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
