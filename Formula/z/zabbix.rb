class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/7.4/zabbix-7.4.10.tar.gz"
  sha256 "8557600b93666f2f89b108e9998977740e08ec35f2a025da30b760822e966bfa"
  license "AGPL-3.0-only"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "466b3b1e5399de8513fc1f21937df5d3468adb064280613cf8149ffc6f11566e"
    sha256 arm64_sequoia: "8f612d594f41b7d34438b9ad81df8e5d290c8de01b3734d57877e02d2c466e74"
    sha256 arm64_sonoma:  "d421892791dc6aa8735690d2927f2afc71273d0eb76c3b88cf24608939955f93"
    sha256 sonoma:        "a6d61ccc9ad4c0bbd774de933067520cf16ad9e0e57e341a02fdfd7daf4f1af7"
    sha256 arm64_linux:   "e3115c480c7dedae0d01bebdcbfe538cf0d485917014e2a3f3dbb29c9cb7bcc6"
    sha256 x86_64_linux:  "3bd37f9e5503a607dc7f8932d9d1caaa6400e450765c632f4678b1e22cab26fa"
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
      --with-openssl=#{Formula["openssl@4"].opt_prefix}
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
