class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/7.2/zabbix-7.2.2.tar.gz"
  sha256 "4d7c7a8dc6a7d333466e7dcc0440e009ab5b7b394cacb4b3291bf693575bd673"
  license "AGPL-3.0-only"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "2f2211d977c01905d4bef29222d69c5a02d666a0e7e97f0223c401d239a74a5b"
    sha256 arm64_sonoma:  "5895a32296ff9c18b40afd16f5972e28c51d1df182d4b6700e4bf62fdb6e4060"
    sha256 arm64_ventura: "9e8d6f1f095a805be359cdfa79ef998936669d8bd9442f4122ab18852a4d54aa"
    sha256 sonoma:        "ee9c5b06397bf4f154cd02f830479e9686c8245ae9e6ea58b116434b0bec6d54"
    sha256 ventura:       "b3d5cdb35401f0b1ccb977c70a8e4790ac41d2a135f32d8fa2c9095ec54edd5e"
    sha256 x86_64_linux:  "7fdf93b9a8ac73a9e24f659b98103657ce0228e7f4fad6b0a23a6731604a1aa0"
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
