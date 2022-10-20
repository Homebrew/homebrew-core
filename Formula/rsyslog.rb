class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.2210.0.tar.gz"
  sha256 "643ee279139d694a07c9ff3ff10dc5213bdf874983d27d373525e95e05fa094d"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url "https://www.rsyslog.com/downloads/download-v8-stable/"
    regex(/href=.*?rsyslog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "77a264afbd4cb7837928db2c5b26d9c766382d4d880e6d1ac9cf6559d91eab7d"
    sha256 arm64_big_sur:  "c91d31f0086438b83a17f9e072974eb760717a6cbbf1e876454633d96affb340"
    sha256 monterey:       "9374aa6c63bc963454d2379affac8286f4ae04843c2e051752c653e8e0b0d0c8"
    sha256 big_sur:        "4675d50ec60509f389554c3773f32d34c1b68dc565985c9057e9001e53d25c25"
    sha256 catalina:       "8197c7d7f1c086a4c5473c65a069e2a7b335bcf76b48f531bc69262f7e9b0e8b"
    sha256 x86_64_linux:   "29bb59016d7acf82f0816a49db21ed4fea2f4d16ec62369c12e3ec5b07b32c6a"
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libestr"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  resource "libfastjson" do
    url "https://download.rsyslog.com/libfastjson/libfastjson-0.99.9.tar.gz"
    sha256 "a330e1bdef3096b7ead53b4bad1a6158f19ba9c9ec7c36eda57de7729d84aaee"
  end

  def install
    resource("libfastjson").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}"
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
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

  plist_options manual: "rsyslogd -f #{HOMEBREW_PREFIX}/etc/rsyslog.conf -i #{HOMEBREW_PREFIX}/var/run/rsyslogd.pid"

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
