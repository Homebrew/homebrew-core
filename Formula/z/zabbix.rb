class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/7.4/zabbix-7.4.0.tar.gz"
  sha256 "7bd56fcd83359e11682eff412d53a0ceb9e39843ddbde0f09eb97faac80a1fa2"
  license "AGPL-3.0-only"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "bcf92f3692a0b37ffc6a6c5543f8fb4e04aaf934de457f51d180d489a0b81cde"
    sha256 arm64_sonoma:  "53cdfb039d6085fa9e69af0dad8ed51dc7665b7e93e1bbf3ff5832c4be09fc3b"
    sha256 arm64_ventura: "0d4647d3a8a1bb47b24c13689f51cdcf9f01b89dbad953100c8292ebc7cb924b"
    sha256 sonoma:        "2339ffd4dc4b439b477d8b5c1dd9beb5e88f213892ae2ab7df29d2f12cca5b94"
    sha256 ventura:       "4ba7c9257d5cbc9d21d6413a1b39b37b5e3d4f82efd34c7200d5470b042dba14"
    sha256 arm64_linux:   "edf95cb13790d5e9220484e0d486cff2b944c59759331f54cfd808e3ac8aa601"
    sha256 x86_64_linux:  "07cfdee4c8dd90368fc2bc691e92ef7bf42942b213cac99eb3ffbb862984f579"
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
