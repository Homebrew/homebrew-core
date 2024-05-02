class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.2404.0.tar.gz"
  sha256 "30528d140ec1b1f079224081fa37df6e06587ff42b02e3e61f2daa0526c54d33"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url "https://www.rsyslog.com/downloads/download-v8-stable/"
    regex(/href=.*?rsyslog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "c3e064c67c3a288bac7aa41cde33b9000ded7c04a356a5a266a945419f698d49"
    sha256 arm64_ventura:  "593ae1ef6bc65f966c45eb82c01d543910c1e858a3462a5e9acb5cf1b4f222cd"
    sha256 arm64_monterey: "537dca1f8b53e4974c8fdeccf993f04b0e1bdf1440ba979cb4f3a3e8b7a63582"
    sha256 sonoma:         "9128ee95bb26a7e226cdf3a3f1176883b7a6853b8d168fc6fa626233e790cfb3"
    sha256 ventura:        "3c23718a275e1a8463bcb4d838f784c178b4acb1491678448bea6f5743785c8c"
    sha256 monterey:       "76f513d5bb7deb2549725c17b8806a5379e28ad940b72da9e3fc5437ce68b6de"
    sha256 x86_64_linux:   "db855ff4500f04fbe6fe7fadbfed0bc6f2667b3f56ad2aa99389d1100b8d3f60"
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
