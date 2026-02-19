class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.2602.0.tar.gz"
  sha256 "4fe5256cea046d77546d36042d090e384184bc24041ecda5d03c03d35d1eabbb"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url "https://www.rsyslog.com/downloads/download-v8-stable/"
    regex(/href=.*?rsyslog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e86c820fbc63e371fe8543bf2ff5365bbec589c2e7cbe4a2872d7d35632d11ff"
    sha256 arm64_sequoia: "95707460e1a5b349d6d675e56b9c0bf57d29ec2cc3dca46b5a32a80953445844"
    sha256 arm64_sonoma:  "98c567808f97893fdda9a0f55f75aad073b52bc262a0f4aec6732ca4485ae0d3"
    sha256 sonoma:        "2476dfb611e2179214663f2f8152c91a3dffe2d64d7bf83578786789a93cb8dc"
    sha256 arm64_linux:   "37bea4b49af501f895823195f150974e661927d5117efceaf8151bf04caefb37"
    sha256 x86_64_linux:  "f62a69acef13cf839170010356966d48351d7deca8a6329e6ebcbf0555067112"
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
