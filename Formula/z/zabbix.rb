class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/8.0/zabbix-8.0.0.tar.gz"
  sha256 "55469ac599fd1443370ecf4288655d4d62109ad3a686711c4f3e0d428338ca77"
  license "AGPL-3.0-only"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "b4c12b7a56015da915f31230e65ba20dccee0cf3af9746cb74ac7a438685f885"
    sha256 arm64_golden_gate: "092107b6433b7d8884edd6fea7bc616a8addb78cbe5619be0eff029d026541c2"
    sha256 arm64_tahoe:       "a80413d48e2f16cd024dc46478db39bbdd4f7806a10c81bf9b04c0d280a4c3c0"
    sha256 arm64_sequoia:     "3f5729633a6f591dbb5fa6a77950ca309e257cbea871e8c7dc691a2fa608e7d6"
    sha256 arm64_linux:       "4ef2a223881b9712adbc34a993d105bd512360c8ec74915035fdd24f99bc7639"
    sha256 x86_64_linux:      "174a2ce5e286943892da800bedfbb211108081781f1e9d163efd36054cb7bedd"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@4"
  depends_on "pcre2"

  deny_network_access!

  def install
    openssl_prefix = dep("openssl").opt_prefix
    args = %W[
      --enable-agent
      --enable-ipv6
      --with-libpcre2
      --sysconfdir=#{pkgetc}
      --with-openssl=#{openssl_prefix}
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
