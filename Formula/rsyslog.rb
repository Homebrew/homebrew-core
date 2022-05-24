class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.2204.1.tar.gz"
  sha256 "a6d731e46ad3d64f6ad4b19bbf1bf56ca4760a44a24bb96823189dc2e71f7028"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url "https://www.rsyslog.com/downloads/download-v8-stable/"
    regex(/href=.*?rsyslog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "5d15c96f760440aa5fe801557b5a725691baf405a8afafc2726995af214a16e8"
    sha256 arm64_big_sur:  "ec3c3f95d2d963060f8e6ce3af78baa00daed34c3e0b6068835cd1b287651689"
    sha256 monterey:       "51f4511a1f43d43ccd6078d45f8b5603ee38a4b3ddcc44b446b3a2e5c99d4de2"
    sha256 big_sur:        "3d0423d8820c44a7537f7861f2491df4d32afa173e0ab463794b633ab7033121"
    sha256 catalina:       "c975464697c4edc55f43408a3c4ab5d7a373d84516a94ecbdfbf78a7844f2177"
    sha256 x86_64_linux:   "b1a80ac8bc85c0e25de38472907119ecb807aa4780ecb0962a13d6fc526f1828"
  end

  depends_on "pkg-config" => :build
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
                          "--disable-libgcrypt"
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
