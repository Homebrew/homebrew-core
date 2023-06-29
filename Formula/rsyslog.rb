class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.2306.0.tar.gz"
  sha256 "f6283efaadc609540a56e6bec88a362c966e77f29fe48e6b734bd6c1123e0be5"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url "https://www.rsyslog.com/downloads/download-v8-stable/"
    regex(/href=.*?rsyslog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "0e87599061b683f506ff7b9a22c2b7336ba3c1f1760e0f3cd87aa33fb091b6b3"
    sha256 arm64_monterey: "89b65620354a74aad09489d9e0fd7e6ff91c22c30ad73768a4783b805cf1cd86"
    sha256 arm64_big_sur:  "a8953dbec76cb974e5cdb0c987ea9db63d2bc1512c191d2d5b0e3cc7a91c592d"
    sha256 ventura:        "b1a7f61656bdd456119dc3800610152f01c1cff08c00a144d9e9800acd860854"
    sha256 monterey:       "9e71497d53ac5436f11043cc80f855308f5861037c70e8c94161c8fedc592d49"
    sha256 big_sur:        "2ebdf312059ccecd04c71684cb93e7e8d16239de6fe67a5ed693f69499e07287"
    sha256 x86_64_linux:   "3039099815eddd25dc2e6ec8e15e96bc266e459184c18c876d52228177d413e2"
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
