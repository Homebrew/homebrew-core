class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/7.4/zabbix-7.4.3.tar.gz"
  sha256 "67551435a5fb90e00c57b0cac793b4d21714368f53901c039b0504130f9ff738"
  license "AGPL-3.0-only"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "fed93d3020f01b258073bf1caf8927a6654b5d5cdec7ed98f069048d5b1498b0"
    sha256 arm64_sequoia: "d53c2cf02879263d0ba9c52d8ed75c123603a9433be89075856575922c0fac64"
    sha256 arm64_sonoma:  "f28d0e285dd203f8e9a137f0ba2850f0f4d66fa8aa5dc4f2ec146c0d6cdc58eb"
    sha256 sonoma:        "2a3fa6dc0e475cbe20438e9981ca3d945c1de3ddf9535d7f5c3afff39f0b6a8c"
    sha256 arm64_linux:   "2a42445ab6705b7ffbc76897be251b7455ee5b071649676e65799297ef4b10c6"
    sha256 x86_64_linux:  "c61fa6cc0293f5fb6efaebd7da44c676979c39dad28ffc7c1bffd9425509abb5"
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
