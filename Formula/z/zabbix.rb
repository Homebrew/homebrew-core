class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/7.4/zabbix-7.4.2.tar.gz"
  sha256 "08d2d584d1390b1cebf0e515280eaf3611405d6fec9867690e4038bd259c3efc"
  license "AGPL-3.0-only"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ee70e62e77cee97ada80cf67428176488c7892718d568fd1e9a596d5ac0139d6"
    sha256 arm64_sequoia: "03c94b39bcc710aa5570f3e6af08667fe2fffdc168f63505d3c1b73eb2385751"
    sha256 arm64_sonoma:  "74489dee6388f9b8b548415604dbb13be79393d249cbd0b29657d048631923b7"
    sha256 arm64_ventura: "de2c12b41c30d077061444beb2ab9fe53cb297d4255d1fd5858294930b76e803"
    sha256 sonoma:        "1ad0b898ac33a25d54c74118a8997784e21cdc9744be7c6027330a4998585f26"
    sha256 ventura:       "3d54fe54ad694cc503f55102c47c73935ee767cbc09d53261ecb7ed33c01e747"
    sha256 arm64_linux:   "2820ba7de40212ed9cd70de9317826439d374a8581b045e22a16e858efbc4ab7"
    sha256 x86_64_linux:  "d0f31577e9965bfc62d96d73b87b2bb18e2a82ba7da020bfb64ca3a3fddedc91"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "pcre2"

  def install
    args = %W[
      --enable-agent
      --enable-ipv6
      --with-libpcre2
      --sysconfdir=#{pkgetc}
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
    ]

    if OS.mac?
      sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path
      args << "--with-iconv=#{sdk}/usr"
    end

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"zabbix_agentd", "--print"
  end
end
