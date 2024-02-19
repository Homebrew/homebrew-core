class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/6.4/zabbix-6.4.11.tar.gz"
  sha256 "92d8e7001189726401e27acdab73060f86261169859a04aa202911dd944b4070"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "4b0688272455b295109caefaaa736a4d5aa48ccaf1208127b28eaf3d4cf9c153"
    sha256 arm64_ventura:  "894e725040449e0ce8c5dff4693d012e2ae5b517cc634dc07176de5359a9d7d3"
    sha256 arm64_monterey: "6677d93a2354b0ec6d4678ca6abec62109fb848f63841e9d602aa14628ed25f0"
    sha256 sonoma:         "aaafa5cc5e3e97cf0190026d10a2db6ebb39bc6c9a6e0edc1021b2fb28bf4958"
    sha256 ventura:        "b9d0b3ac03dc053e43039d1c9c0d40e790602d80de180a95e740d4139c79f069"
    sha256 monterey:       "fd15c6986597b1a2bbcdc5f906c4e456cccb248f6384d325267135d655a99a52"
    sha256 x86_64_linux:   "b98fdcc83b65e321e944e00ab12f147259230e80a35d419c878eff4033d1a3b9"
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
