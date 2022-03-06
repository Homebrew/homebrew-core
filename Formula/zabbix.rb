class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/6.0/zabbix-6.0.1.tar.gz"
  sha256 "2dd92383cc169ce8b8cbbe660ed656e5d6b5b75bf4936743b8a9d59cdfcf3af1"
  license "GPL-2.0-or-later"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "d2c96eeb37ebc246fe3171de5f900aec6189ed4946844c8f0872f2b75c9b50dc"
    sha256 arm64_big_sur:  "1569bae14f5054671fb54e3c94c9da802b12dd16863b49ee32fd24e28524b32a"
    sha256 monterey:       "ac6392603319c73b25963b91d51f8bfbb76c36c086f0e2e579b915377c65a37d"
    sha256 big_sur:        "f1e8a897c385603c072b98da21b5908cdb99729eadbc7128dd4b55ea044a6c94"
    sha256 catalina:       "e656447f9657359d93de86be52a6a354007b92b8dc12df38b0a40302812c6cd9"
    sha256 x86_64_linux:   "4463852d2dc0d9034485074bf6771e6c2128d8a1a1c65e79f4838f8ed0c3202e"
  end

  depends_on "openssl@1.1"
  depends_on "pcre"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}/zabbix
      --enable-agent
      --with-libpcre=#{Formula["pcre"].opt_prefix}
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
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
