class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.2310.0.tar.gz"
  sha256 "20d9ce792bf0a7ed0703dbf0941490f8be655f48b55b4bebdc0827bbb0ddbf11"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url "https://www.rsyslog.com/downloads/download-v8-stable/"
    regex(/href=.*?rsyslog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "97dff6a7b3650b7769cd5869eca0b6c308eadfabec145d71632fc17249d242dd"
    sha256 arm64_ventura:  "259620be4bac56c0889b7244a406297a259a57f93a786b69ffba3235e85d92b5"
    sha256 arm64_monterey: "f4c6bdcdc04cb397d89366b967980f628a526d0a8dfea69e47ab6348af4d4362"
    sha256 sonoma:         "c3dfc655354009736f411096a6d253ed934841f346a8e1e6f3bcedd4a3cf9286"
    sha256 ventura:        "a70f4f2ceffa5330dde66f5e10e405ceac04db06500d106d4825b8c87217192c"
    sha256 monterey:       "43663e4a758cd285124b42fd12c99f0825f6ae3c8c6acac492855b1821dd4d95"
    sha256 x86_64_linux:   "07fa3efd9d944a3635da3772da745f6a7960acdf1317dbb81f334230d7b0e6f4"
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

    (etc/"rsyslog.conf").write <<~EOS
      # minimal config file for receiving logs over UDP port 10514
      $ModLoad imudp
      $UDPServerRun 10514
      *.* /usr/local/var/log/rsyslog-remote.log
    EOS
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
