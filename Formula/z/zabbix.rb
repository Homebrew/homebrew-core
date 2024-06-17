class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/7.0/zabbix-7.0.0.tar.gz"
  sha256 "520641483223f680ef6e685284b556ba34a496d886a38dc3bca085cde21031b1"
  license "AGPL-3.0-only"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "f0d81839c2648d47e14c54adfe51aca63caddcdac548e0965d306be44085404a"
    sha256 arm64_ventura:  "c0ef910b073f1d058fe9805c87d22f4d2e5486f37d979268272b8e8c343828ec"
    sha256 arm64_monterey: "6495daee0c1ab589ab29be8b3ba631b3d3469512036a05ef180e86a571a37a71"
    sha256 sonoma:         "1b8508d6d65f8a7f5fdedd97fb75c0251e7ee9551acf4c2290d45264119e55c5"
    sha256 ventura:        "e5fe424800039463641ee47745c93a34bd252b945d71c32da1fd437d0ceef331"
    sha256 monterey:       "835f34cbf05d3594dbb9b019bf96e385c8fde17473d8234ef3c4196a81f5fdac"
    sha256 x86_64_linux:   "e056faa5a13f39da288273d75712e0b7519976f8741c569c5640b97ffd7444d1"
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
