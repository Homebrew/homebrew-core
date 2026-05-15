class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.2604.0.tar.gz"
  sha256 "2a04b1cd6f0a5e2b60eec231acce3cf9927c4ed02bc5fbbe5dc4c35fcf887b64"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url "https://www.rsyslog.com/downloads/download-v8-stable/"
    regex(/href=.*?rsyslog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ac940ccc2bad665de82d87172ee265bffbbd7830d61982c164a3581692a21520"
    sha256 arm64_sequoia: "e6119ab21408febc7fd07ed7ef2a4f1498a9a7a9d29a9ea78618f4df4f4f54d1"
    sha256 arm64_sonoma:  "1b0b99a5514977571d829fdeaae9df573b745a5bd7ff5dd02b09bd7332ecf453"
    sha256 sonoma:        "d00a64376b1149cbc2190b6756c456036e2bdc1216275cc8cc872de5a0425899"
    sha256 arm64_linux:   "40c6fc9a9ffd047e4b1a2d931624ca2910c3da52f2fe10088ae29eec6e13e502"
    sha256 x86_64_linux:  "e1f531545831c8af04a56fc70d4e9b60bbc6ec55c11e27f12a99f9785df8d4a7"
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "libestr"
  depends_on "libfastjson"
  depends_on "protobuf-c"
  depends_on "snappy"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
