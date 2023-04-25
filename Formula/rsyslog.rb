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
    sha256 arm64_ventura:  "0a4fcad36d21b12b9cbfa594a847a0e06edf54472edaffd23f6ac3f433953ccd"
    sha256 arm64_monterey: "80c02825e6a0af2cbd25c43c69b56fad0376e0a847429878e0044ecef8c2a51c"
    sha256 arm64_big_sur:  "96f9efab15f6f918fae94b6bbb9d606054aec4daf05c4de1f021fec011a58cc5"
    sha256 ventura:        "950cbc5384ed9cb58ff35ca03212b91b59383138549af632c0e20f11b101049e"
    sha256 monterey:       "37570aee68bdc7b2cb7686550ee2d57eccbb79bdb2bd17de30168b0aaaa673ff"
    sha256 big_sur:        "42ea1e3c316466a6520bfcc246be05b5f4daa92a53e5c68d76b390bbd26b42f3"
    sha256 x86_64_linux:   "3aff4c470389cdf5b5669780422a6c00d28eefeb7cd929a694c3b80c671c0ce5"
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libestr"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  resource "libfastjson" do
    url "https://download.rsyslog.com/libfastjson/libfastjson-1.2304.0.tar.gz"
    sha256 "ef30d1e57a18ec770f90056aaac77300270c6203bbe476f4181cc83a2d5dc80c"
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
