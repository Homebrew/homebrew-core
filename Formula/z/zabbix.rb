class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/7.4/zabbix-7.4.13.tar.gz"
  sha256 "ebc4fb054af919b123622feea9d4c399711cf0507ef193e2ded76713a80ee3c6"
  license "AGPL-3.0-only"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "8ec39fbfda7a641984f7a2476a8c731b1a3460965a942579d51bb25e3a09c89f"
    sha256 arm64_sequoia: "97a61c7e877e59eb7ae58c7792d7c270e7c450e11f6bf8636bc335ea0d426fb3"
    sha256 arm64_sonoma:  "303e3c1227bd7e297ed478c8a4ef56049a54b3287fbcf55a5eb2b8bab391f6f3"
    sha256 sonoma:        "35766aa5815d4b57c23d2dbc46ee182d27e4cfd69ef82724110c9a75413c670e"
    sha256 arm64_linux:   "c566a03f33a312988ab70aa828d3eff1c379f692ae9b42a64c8595817d6c9af3"
    sha256 x86_64_linux:  "4afbc3370a25164cac2c939656fd3ae711e95d912ba63e7fa695e11970cc1769"
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
