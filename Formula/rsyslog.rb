class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.2304.0.tar.gz"
  sha256 "d090e90283eb4b80de8b43e5ffc6e4b59c4e3970f2aa91e63beef0a11720d74d"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url "https://www.rsyslog.com/downloads/download-v8-stable/"
    regex(/href=.*?rsyslog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "7c28d7ac286961945d9d94d2602314a1f836d51317f782c13792ef5c7ce8a63c"
    sha256 arm64_monterey: "8e1d1478dbe04792e3fcdaabb11039d7fb6ee011716fe53d45afe8cf17f618b3"
    sha256 arm64_big_sur:  "84d48f4d060fe89ddb784f880d0666e22586d65b1978db7719736f34ef4b23d1"
    sha256 ventura:        "93bb527c222a85449573cbbe22137dc39277f8676f37c02e2de61b4b37a45be5"
    sha256 monterey:       "29052d55ae75a2cf960252b1ad7366908b8c284f56458d92e08d2d70c557b19f"
    sha256 big_sur:        "219d5a2608ff6df605e36ed4c144a5b4ae04abd896a395e2b56949e8f385a5b5"
    sha256 x86_64_linux:   "f3306a02691e7b4b48c009a9191b1c9d2a21e09eb98603099cddf59cb6cfafb5"
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
