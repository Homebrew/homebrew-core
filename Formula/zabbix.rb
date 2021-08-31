class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/5.4/zabbix-5.4.4.tar.gz"
  sha256 "de9985978cf9638d7cb208f7f65d93141b4e1256ead56df1b95d7bda41d6a672"
  license "GPL-2.0-or-later"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

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
