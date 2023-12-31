class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/6.4/zabbix-6.4.10.tar.gz"
  sha256 "dabad1af52ec5f3b65ca3d5001e5782cd731d104394a7183bd81dfae5d6abd25"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "1833078d632bca4c5293e6327884c21b5b797d330a7dbf252db355a213942f72"
    sha256 arm64_ventura:  "45adfbee9109dd325c84dfd169dc9c63460840e933ac53e0ceb22b6f30cfe92e"
    sha256 arm64_monterey: "958a3763cff6132e9a832d2d50bb6cad9ae2977bbcd6ddcc8f912138b724232b"
    sha256 sonoma:         "80d0b52b774ef3214e54526143c3c37033922b1278cd798a43e0406b682123b6"
    sha256 ventura:        "59c0985ad097d7fa51c79fe7b2ff56b2c62ebc4b0d645a00f331b728361d751f"
    sha256 monterey:       "13d4d80b5125caf7cc5aed8af4b91c27d19212a167ce11585e4b565c25f26911"
    sha256 x86_64_linux:   "5ec553c4f0a3f225b8822e6122591b8f843f0278d6315f4e4135c1ade357c996"
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
