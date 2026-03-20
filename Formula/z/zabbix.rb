class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/7.4/zabbix-7.4.8.tar.gz"
  sha256 "a9b452b6c574d22829ce20693a1aa9cab88bf0f585b7aa2a6a3ad4cb14dd3b1c"
  license "AGPL-3.0-only"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "1b5c89699d828dbb8317bb7f13ca2026d1bd0d044694090f94e3602e06db2874"
    sha256 arm64_sequoia: "6f7ea3ff2f2358a9f0742404a396cb683052477cd7d658cccc5426aab08d8ca2"
    sha256 arm64_sonoma:  "8619e96da1af4766ff2fb4649c44b6e7ff2e944799c0a141f10eac18a20b4ff3"
    sha256 sonoma:        "9e99c7eaa032a57a503c5d91d24d6745ff7989353228050b687d743082f732f0"
    sha256 arm64_linux:   "4244593412e448e5f2bb07868fee7e5b3ac840c8db99b2a85ce54b61c94c9bb2"
    sha256 x86_64_linux:  "0c0e71b20721b41fc395a5a76a91269330c76cc796bdcf8f40eb5f3fc7431a9f"
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
