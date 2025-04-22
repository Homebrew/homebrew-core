class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/7.2/zabbix-7.2.5.tar.gz"
  sha256 "0d01b393dd22b2a60b36fb37a98fcf1081c683ad98832a2ddd87943a1200839e"
  license "AGPL-3.0-only"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "588bed43b97bc0bd12b900c1da26cc133983651c0dc81c889b872986f853367d"
    sha256 arm64_sonoma:  "46528a3d815de626658df8e3d9f05661251462989f8beaedbec6d59c66bc5ae4"
    sha256 arm64_ventura: "dc8ce2f22c41d292992d0dde0ee38dedbcc58c985af21986f36c69aecd49e185"
    sha256 sonoma:        "12b53338dd96611ddfcebbff3bd99f6fe65166cf62ae1519e30e2c40c07e8590"
    sha256 ventura:       "05ab91b029f5f97e0c8b31755517e33588c433dc5458dd79a1472f4da47bc001"
    sha256 arm64_linux:   "618d86ea632f022a6c409cbf728f1d770493bf1855b7738f9cb959fed642e4e8"
    sha256 x86_64_linux:  "8bdf48b54a69c5a34c90431812a3e13c9d10721e04f574b4bd46039e62bda90b"
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
