class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/5.4/zabbix-5.4.7.tar.gz"
  sha256 "b472aff806e0f61d184b2b12cc8b15e65718b44edc3050eb1ccc5b407a6d7209"
  license "GPL-2.0-or-later"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "2eeb720a69eb2bfa0fcb1966c5b6384a970f4cf58e1be722900174dfe149f5b4"
    sha256 arm64_big_sur:  "ea2f93eaa54ee607cd372d6c126c63032396219b7024c99d31aa9a43d663f6b1"
    sha256 monterey:       "b85982bf28e62fc9dc11da524d6d977a735cf688430111eea5d1f925c696266e"
    sha256 big_sur:        "d4017776046836bd1085af245084d68e96cdd5f3285bd596586c59150138aeec"
    sha256 catalina:       "b7d8988601b32f7e1bb5cf7421bf761444def00570f3b18f208de3e1a9027353"
    sha256 x86_64_linux:   "5e44c05af49d4d6412deca503648b77b8898dc2af66c9ca0847cfb54db035159"
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
