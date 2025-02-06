class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/7.2/zabbix-7.2.3.tar.gz"
  sha256 "fa957c533f042ef9b37710b00ada9c8e4c8063819d87c80212103abd53ed10b5"
  license "AGPL-3.0-only"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "7a8ba2dc907d551fb11ff4c96b974f854a75ea02a8f693bb567ce1f12c3cc926"
    sha256 arm64_sonoma:  "c137ce402fb87a27825c2892cc24603e215c693c538eb78c7ecae8a2351038f3"
    sha256 arm64_ventura: "a2f7f51107051806bba51515f80f486e30c1036605695970728a5a2d43ab48e3"
    sha256 sonoma:        "3a4362a626d430f977ebb845ad5a48fe326fc53d6effb3589ca0b3a26cdb0dda"
    sha256 ventura:       "adb44dfe116baf3e72ff8a43126e4def9c9fd0ff736f8f0e10c4675746782991"
    sha256 x86_64_linux:  "c38ab3616ebb211668f584cdd4257a06b7658cc073a6cc008ba85c0075b675e6"
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
