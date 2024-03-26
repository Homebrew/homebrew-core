class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/6.4/zabbix-6.4.13.tar.gz"
  sha256 "a92ba21b0679e3abb3a8bfa0b6e16f2b5363bd50460eafec6da4d7050f32b092"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "786238b65ff14f5f9555fb6a9d518695b5e01e4a0dd4298b5dcceb9ee90cd4e1"
    sha256 arm64_ventura:  "4cedef75f53a7e3ac2cf4c8fb798449421ed01f9627a6be86dbb7afa4be7c998"
    sha256 arm64_monterey: "0d085ad165c820ab7478b9d25bf794c61a3d35f52bd20bba058654efcd847f47"
    sha256 sonoma:         "46706181b3bcb4e261f6e496ec3f4fafdea25e53b80cd83269392437e1f5b82f"
    sha256 ventura:        "5ec0e2e3c2a4fe89bbbe4d1f501704429d6acac342af131f6c93af25ccf31f5b"
    sha256 monterey:       "0d0646dcdab82e25a0235a10ebaa8f90795f3b2baba7984d18dfabf6ff449fd0"
    sha256 x86_64_linux:   "7b03d29527880ad4087760c0fe4e90d9c1e6336f0ee6a83df37feace4dc25939"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "pcre2"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}/zabbix
      --enable-agent
      --with-libpcre2
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
    ]

    if OS.mac?
      sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path
      args << "--with-iconv=#{sdk}/usr"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system sbin/"zabbix_agentd", "--print"
  end
end
