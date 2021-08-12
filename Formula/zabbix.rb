class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/5.4/zabbix-5.4.3.tar.gz"
  sha256 "dbbc843c8119f1f63d7378588d5eb5a46c22f32f86428bb79b9872191342bbc2"
  license "GPL-2.0-or-later"
  head "https://github.com/zabbix/zabbix.git"

  bottle do
    sha256 arm64_big_sur: "035570354333169d9f8e7a43ca0a0707e9adb004c9709dc00b4b2e02a7977436"
    sha256 big_sur:       "343653c7f8968a11db3355add8bc11883f20f9765a38ead4d452321b97cba19a"
    sha256 catalina:      "7de5a411b7e986fbd88abfcd91bfcd0a9f946d184b042441b4e25674786ec42a"
    sha256 mojave:        "c6c99115c81c102471826b0f61c4f95ee47d386bafca3859177a5456b986d886"
    sha256 x86_64_linux:  "ff7e59909b33853b63a02c3afbd5f26c72f0c984aa8a69b0da8ccd1c4c1d7c7e"
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

    on_macos do
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
