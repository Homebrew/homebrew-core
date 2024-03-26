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
    sha256 arm64_sonoma:   "d5cf5f93d9786c454bb21444c31499810e9d33baa41074ebba71655553f07c89"
    sha256 arm64_ventura:  "eb0b5d7fd4e571fe1e08428b5fb1fedc07a90ce742050f036b2ddb622f94d785"
    sha256 arm64_monterey: "0f10fae866a36183b42bacf10bd4584629ebffe3d8e27cd9069c467c89d11180"
    sha256 sonoma:         "2444fcc342097829ba1462af8ec6efb8a601ca45f402b638148ecad05c6fc5df"
    sha256 ventura:        "4e37d3571530d8dcc08c9c0fb41ec3b5f62c7d179f352e6ba0e1319d0d2cc397"
    sha256 monterey:       "03c426abcad5c75bb47e7242a229223c1f55a36a0ab22735758b12514d2f68e6"
    sha256 x86_64_linux:   "a055b92efb4f5b5f2148faa927a701be532e0a802717f8bca818f4933cb204de"
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
