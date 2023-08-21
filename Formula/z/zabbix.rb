class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/6.4/zabbix-6.4.5.tar.gz"
  sha256 "8761ab337826b1b705678cbd07d22400085718bef893b64718931c6f4f54eede"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "0a7a5d073cd0c1892ff6374123d307d53294b19ddbd25ce7d3da4d14400ffb95"
    sha256 arm64_monterey: "4f832fe25bb2ad7f70b6e966b062cdae1a0db850775fc28f364917fc431aba22"
    sha256 arm64_big_sur:  "fa4db57087b9aa3c7414555945ba843bc7704297b5bcce646dc3cd1c34a86eba"
    sha256 ventura:        "c1714c8aaf73e03012494344215424a0eb5d2195fcac2354d5e35632a426c7a5"
    sha256 monterey:       "3a0e4539b878496c36ce4fa66fd72dbfdf03e3aeba931fe192a34b103c18626c"
    sha256 big_sur:        "f06ee63967a91a1432ed1173ce5d1c46f3a7bb3410d906ae482eab815b76f82c"
    sha256 x86_64_linux:   "c22e86aa28087def0995929dff6420d68456eef9c6aabd0aaa73682376827b0c"
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
