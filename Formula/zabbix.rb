class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/5.4/zabbix-5.4.5.tar.gz"
  sha256 "f34294bde635356b8cd1cf522190813a818650389c85bdbc4609588f2dcc1406"
  license "GPL-2.0-or-later"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "56592846f55be4fe0f78cc66e1be0d50b3e7053288c7eac1c9de6b709b51ac15"
    sha256 big_sur:       "5e92c79a7489764634c5fd34ee79f6a770accd64b22a618577638916379d098d"
    sha256 catalina:      "919aadadaae1bb3f1519b328cc6387dcf890192c64ee0cfe1373b4d04a5f7e99"
    sha256 mojave:        "b86cc4374ea7dbb3e08bcc64b8964e70b4f9a43c13c40b8ce47bac26ebb6cd34"
    sha256 x86_64_linux:  "1d4ebe7e3d5d92f4050cb748f2c7e2e24ebab198faaa85a309e132cf6041a8f7"
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
