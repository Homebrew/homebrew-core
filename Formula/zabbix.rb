class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/6.2/zabbix-6.2.3.tar.gz"
  sha256 "2be7e57fb33a55fee71480598e317ffa6a8ee5a39639a7e1b42b2ea6872107b5"
  license "GPL-2.0-or-later"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "54e290f946b05442f6aea69e14df76ffc39448960e7f35f834f5d7aaee79aa87"
    sha256 arm64_big_sur:  "95daba9c12acab84e686f13e3c7612438ebe0958a524f79ceb0d3818f086b2f9"
    sha256 monterey:       "5e37f05abc4f086ca020a694dfc59a01829b86aab1b2bbdef57cc89442cd17ff"
    sha256 big_sur:        "c21f9a3ded5f9a4b907b09d40672ac2374f4be5033c5ff90ea029ac1f463fab7"
    sha256 catalina:       "85be8059ec39f94532c9a8458db4d0c533cd4cfbbad8bf19e3612353670588dc"
    sha256 x86_64_linux:   "9ee9cd71552f20b44206ea7bbaffd8edd5e9587377272bafb69a0a0cccac4cd3"
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
