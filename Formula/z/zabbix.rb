class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/7.2/zabbix-7.2.7.tar.gz"
  sha256 "323f7c1c2001c029f41c0207fe4493a072c5bde97b60ca3f591529037c0fa56f"
  license "AGPL-3.0-only"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "2251764d8ccc48324ffcdee67ad581f726dce9139c458b591945c2eaa5697abe"
    sha256 arm64_sonoma:  "e7e0ead750c128921c3d31d529be0c9fae11916a35a17abe2706c2d3dec79569"
    sha256 arm64_ventura: "4c689d287ebecab078da4a1cb36b94b51018c306c9a9598899edeed8107dfd36"
    sha256 sonoma:        "7bccc9f2c9e1c19aeb20364da8b0f34fdc57be9c4269068e277764bf570ba2ec"
    sha256 ventura:       "52f84a923659aa53ef8ffa626a95ad4e8beab94a1f4fd1d8789ba793977a8c81"
    sha256 arm64_linux:   "2b93617a958287994f9a47cd74ba1d62ec6082f67493cde5ab4ed0b4eb65750f"
    sha256 x86_64_linux:  "0537ba449e98fb87f6e400f84268ed59570dc197f80ebfd4beb23067f46c81c4"
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
