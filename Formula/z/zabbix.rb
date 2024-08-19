class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/7.0/zabbix-7.0.2.tar.gz"
  sha256 "4279415bccef72ec85f9f9ab21ffe8e3731feb5be89416117917800e945fa180"
  license "AGPL-3.0-only"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "189dcaee0c26505a416e25f881c88ce00410aa02b8f872889a8e9666ec50c02f"
    sha256 arm64_ventura:  "46d29001b177587341cc217cd8ca2da42d324f19fce6f67e8ee6b034ea87f884"
    sha256 arm64_monterey: "8b4b018d42daa857faf421f911c7e71904b42356838e2439725c1ce34a873ec0"
    sha256 sonoma:         "e6684655b47ca859579e8085fbdd086c4420503fa8219a2892258375f9197f40"
    sha256 ventura:        "08eb69fa8bf11e1d33410d0299b755941c9cfaeaa744e6b2242e565693ea947a"
    sha256 monterey:       "7217e11d3b46662e10fb816472e68ce7e97637f9760783812efc5daacf77baea"
    sha256 x86_64_linux:   "31faa04bc5a5439f850cfcec041eaa225671f54b16aba97991ef20c429a4a577"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "pcre2"

  def install
    args = %W[
      --enable-agent
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
