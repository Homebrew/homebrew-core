class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.2406.0.tar.gz"
  sha256 "1343e0269dd32166ffde04d7ceebfa0e7146cf1dbc6962c56bf428c61f01a7df"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url "https://www.rsyslog.com/downloads/download-v8-stable/"
    regex(/href=.*?rsyslog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "1c1217b07cc45de4691075466a709ffafdd81e09ef810d3dae8bcb822d527650"
    sha256 arm64_ventura:  "3970aa36858f51888ad3219c6d72dd6456a12e19425633b100a11d8b5cd87ed0"
    sha256 arm64_monterey: "b0cf2770289dcfa3f9bcb6f08e5c037ff704e4312e9b668195f32594fe9643a2"
    sha256 sonoma:         "cbc70a0150369860dd6d4c56ecde3271ebce065b85617a931f78a27411a638ad"
    sha256 ventura:        "d0b308eba5d6f15ffd4beda39e75460054a0ce9fa3e1de3c6b88704f07c8f1f4"
    sha256 monterey:       "2b9c02de843c538f771557937f450034698f144f940989a70696888e1a4f2924"
    sha256 x86_64_linux:   "af8603343dc98f219a64e36e3524d8e9e8e3564b524df4541259282a0a07cb2e"
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libestr"
  depends_on "libfastjson"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args,
                          "--enable-imfile",
                          "--enable-usertools",
                          "--enable-diagtools",
                          "--disable-uuid",
                          "--disable-libgcrypt",
                          "--enable-gnutls"
    system "make"
    system "make", "install"

    (buildpath/"rsyslog.conf").write <<~EOS
      # minimal config file for receiving logs over UDP port 10514
      $ModLoad imudp
      $UDPServerRun 10514
      *.* /usr/local/var/log/rsyslog-remote.log
    EOS
    etc.install buildpath/"rsyslog.conf"
  end

  def post_install
    mkdir_p var/"run"
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
