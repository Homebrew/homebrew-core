class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.2512.0.tar.gz"
  sha256 "93c50025d90b6c795fa350d56a3d832bfce45043ea9bd68240d9c2a9394bc629"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url "https://www.rsyslog.com/downloads/download-v8-stable/"
    regex(/href=.*?rsyslog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c2db8984acc93f4ba08df481201f0a1b453667ca6c3cdcdee9dfa5e09b53031b"
    sha256 arm64_sequoia: "1f27f4f152d39ea634d38240a5189678e46bfb2fabb0b67e86897867e46fe5e0"
    sha256 arm64_sonoma:  "f353642ec2e7a8c2426b68537b4f57764c298cc8b8049965173db2345b5e1bd0"
    sha256 sonoma:        "7099a72ee3a37a07338d8a03b1032a47bb1b3cf601d4876be3073bada2cb7efb"
    sha256 arm64_linux:   "aea0fa66d5662bfd917fd4fb2946b47ddfaeea25754159398994e4ba3c3c3a05"
    sha256 x86_64_linux:  "aae84034d0e933bf106ade3111c86a6d4b5acbf1d16f2a14fb8cc07f275973bd"
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "libestr"
  depends_on "libfastjson"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "./configure", "--enable-imfile",
                          "--enable-usertools",
                          "--enable-diagtools",
                          "--disable-uuid",
                          "--disable-libgcrypt",
                          "--enable-gnutls",
                          *std_configure_args
    system "make"
    system "make", "install"

    (buildpath/"rsyslog.conf").write <<~EOS
      # minimal config file for receiving logs over UDP port 10514
      $ModLoad imudp
      $UDPServerRun 10514
      *.* #{var}/log/rsyslog-remote.log
    EOS
    etc.install buildpath/"rsyslog.conf"

    (var/"run").mkpath
  end

  service do
    run [opt_sbin/"rsyslogd", "-n", "-f", etc/"rsyslog.conf", "-i", var/"run/rsyslogd.pid"]
    keep_alive true
    error_log_path var/"log/rsyslogd.log"
    log_path var/"log/rsyslogd.log"
  end

  test do
    result = shell_output("#{opt_sbin}/rsyslogd -f #{etc}/rsyslog.conf -N 1 2>&1")
    assert_match "End of config validation run", result
  end
end
