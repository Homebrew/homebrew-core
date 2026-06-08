class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/7.4/zabbix-7.4.11.tar.gz"
  sha256 "ba8b85df396b83be92169c64ec4027d7e1ec79d673186ff481c2aaa8e5246bec"
  license "AGPL-3.0-only"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "00f0bc4106542ee5a49990164b71318e62f41d98612318d6db88e8fc4e2ec58b"
    sha256 arm64_sequoia: "8ec566ab871fd56ef4d047078e8776ce4e4866a7567d71fa9a06e534aded35e9"
    sha256 arm64_sonoma:  "875bf6618c6b3be27e7982e56e1766decb70fed3c446436863d085001c208b09"
    sha256 sonoma:        "e7f1f7f4febb99dd8aea9583519e52bb651225c25407d78893f4e925f11d41c0"
    sha256 arm64_linux:   "d5490165e9ee739b3dde81927b4e45b886c32e9b7a0cecd3694da784dc72f917"
    sha256 x86_64_linux:  "faff1df17bd1947c86e36720f6eb39c3aac9f03c375531a91da077bd983ee279"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@4"
  depends_on "pcre2"

  def install
    args = %W[
      --enable-agent
      --enable-ipv6
      --with-libpcre2
      --sysconfdir=#{pkgetc}
      --with-openssl=#{Formula["openssl@4"].opt_prefix}
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
