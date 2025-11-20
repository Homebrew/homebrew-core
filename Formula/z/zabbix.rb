class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/7.4/zabbix-7.4.5.tar.gz"
  sha256 "3eae4bc712f530b2df6624cba03ce23e29b2a11aefac0b6d4c27a64d425fdfc8"
  license "AGPL-3.0-only"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "cdf3b7bfc84c7868c562ce989528e29df6ac0b24bd55c3582ea7e35aec8ba255"
    sha256 arm64_sequoia: "a58fdf6c6cdb25731a7c9f33d81575c874c1dbe3caa2d977c75118c29e051e05"
    sha256 arm64_sonoma:  "7d0e4ee0dd180b439988a9b5dd7186dc67eb788cea976248ee729a5d60ca6db0"
    sha256 sonoma:        "88187174c74addb3e7dc6aed67d8295f25cca2d418121bd5b6f119fcc37ee819"
    sha256 arm64_linux:   "5468734596704cc537ca3775a42526ac0d4bc5672106539a009cd0b2b275abc9"
    sha256 x86_64_linux:  "91608df7612293680de2d0662eb67cdfee576c96ad3b67282bdb67ee8b4cc953"
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
