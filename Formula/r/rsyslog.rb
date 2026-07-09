class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.2606.0.tar.gz"
  sha256 "2574b3f3068e6955eb94ef5643e2b6a5b8585cc8eaa77209ff5cbc1e2e5f71e5"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url "https://www.rsyslog.com/downloads/download-v8-stable/"
    regex(/href=.*?rsyslog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "9698e1a93005d87dd2e77f3d87e8a23304c998dcc3d59fc3c9cfefd8960ab25a"
    sha256 arm64_sequoia: "4f12b7120c7e5c12df98a1d7ea27f48567e6b62745dfbd9ef1306b5eb041d4a6"
    sha256 arm64_sonoma:  "bd8e38d40c822d70d0026abea67926dd18c2f0e8e1148c0459b6fdb74e198f35"
    sha256 sonoma:        "5a5567dd02218465db90038d610551e702d5e5ff56d86cbc32f01c5c37247ae4"
    sha256 arm64_linux:   "7d925c77716c6d560f7c69b4a6c17b92979ec232661b6b3a3f4782cbb2695ab6"
    sha256 x86_64_linux:  "de533a48fcba460aafa051fa0e708c051dbbdc190ea28732594c834ab1dc7ddd"
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
