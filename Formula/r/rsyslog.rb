class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.2608.0.tar.gz"
  sha256 "e3d60c83405268c422f95feec740455a1cc4b911d00bd8424d5d1272bc509b1a"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url "https://www.rsyslog.com/downloads/download-v8-stable/"
    regex(/href=.*?rsyslog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "608db8692ff14d11305b87b623e275fdf681e75bef9c1da714e499e2de1c4b10"
    sha256 arm64_sequoia: "2b2590d9569825409f6b634c9929c40bde2afa9bb78b4ffcdb20b7992da4bd95"
    sha256 arm64_sonoma:  "f68e48ed0a6da73b190f84582743c677afe411e6491a9e0cecfa8088c5077f57"
    sha256 sonoma:        "76fcad59dae37415494bfc26c54e1a79b3a5d5ca829d6226ad7095677b9c5ae8"
    sha256 arm64_linux:   "35807eff264257faa5d95b1ef4a8b301fe9da149b06c0244c7851a6428811ef1"
    sha256 x86_64_linux:  "a36e4d7065f844c85af04b82e49a5bf31f83ef6150029ddd14c40ad6228f16a2"
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "libestr"
  depends_on "libfastjson"
  depends_on "libyaml"
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

    (buildpath/"rsyslog.conf").write <<~CONF
      # minimal config file for receiving logs over UDP port 10514
      $ModLoad imudp
      $UDPServerRun 10514
      *.* #{var}/log/rsyslog-remote.log
    CONF
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
