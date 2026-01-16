class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/7.4/zabbix-7.4.6.tar.gz"
  sha256 "ccc1b0d69b04173b0e7aeeca9478bb6f5d4999c71d4ed50f817351bf011a698b"
  license "AGPL-3.0-only"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "5ae255a5063eb4f046e74e2d7b3d91292dc972cb6476c229824224c2fc46ac29"
    sha256 arm64_sequoia: "9ac92e1015e04688d0413bb9a2fcddc68845ab3a8d8e212b48653125a058befb"
    sha256 arm64_sonoma:  "d38fc1f1a74ebb5ea38430d90875cfc7398ea5fdfe4a803822f76db2d726eb4e"
    sha256 sonoma:        "a43a349f0d2167f32aaf156bf2ed4bab67b803a0841911960a9e3c0a89ec6c84"
    sha256 arm64_linux:   "fde06aaf4b948c0af6dd3d1e1ab8dea9c76e65e468b706a7536c4a809227613f"
    sha256 x86_64_linux:  "5495d582bbac3785e8c86f956ad47003b244f5ba625b0104dd784a8e8b7a9df0"
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
