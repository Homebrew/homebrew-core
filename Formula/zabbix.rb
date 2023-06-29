class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/6.4/zabbix-6.4.4.tar.gz"
  sha256 "c29344b0c700cecb3183fe9f86086d5d12ba0bb931fced5b6ab866280ac66f48"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "a14ca9b1ca5b9b4b0f1064551ff7a0a734d77b6c4090a6667d91a8c4a9aefa8b"
    sha256 arm64_monterey: "c1e3e66de192896227045cef35806feadb55736fa627c5cfa3446d46f7f70739"
    sha256 arm64_big_sur:  "2b5e0aa44028ba67ec94bff78af2a6fd669fec5e29a32924bd2dcb1778cba240"
    sha256 ventura:        "a82c606a84890899bdb34af0c854ea8a075593ee861d5fe48a0e2e067504eaa1"
    sha256 monterey:       "0b67ebd4f50445f2aecabe9bc8c4b677d9a3d7e2ef3e92241f3419d93f6a5ee7"
    sha256 big_sur:        "309beba0f8f35acf95f6b341a0288776bd700d8cb32690a2dd5d9758c699625d"
    sha256 x86_64_linux:   "541c7099c0dd3598a290790b7135553ef57653a99192ed366c2bb448782fdaf3"
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
