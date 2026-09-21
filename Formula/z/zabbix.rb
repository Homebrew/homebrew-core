class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/7.4/zabbix-7.4.14.tar.gz"
  sha256 "efde5f6f19896f0200bb5245e3866035667271c7b1e84626d26095f24a6fbb42"
  license "AGPL-3.0-only"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "6d442bc74593b61457eebd586b756dbf22e7175c17945b1a5cd17eb5e5aa784a"
    sha256 arm64_tahoe:       "2dbd0680694752a8417e7834690221ca2d7ab220199df798938d3b2cb6df5ce3"
    sha256 arm64_sequoia:     "776712e3fa8cbe3fb2a99431294d4114d7c3c77c2e6735a3764e756de647fad2"
    sha256 arm64_sonoma:      "a402fd28db29580197e5c7860d05752b57978c102594fd4873b32d0e4778e0b7"
    sha256 sonoma:            "a7b4c8d9bd37b3f4c98e69cf1d6206505f9ea9e2778b335e26eeb891d3a0e1bc"
    sha256 arm64_linux:       "ecd0b5cad1a013eb2bc04feef23eacdf9052655a87d7d109aea7fc1bdbfcdd7b"
    sha256 x86_64_linux:      "4dc83a49acd8e761a7b74e992b5890f6deff32ca3d8778eecd4c547b35fe797f"
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
