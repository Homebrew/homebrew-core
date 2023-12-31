class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.2312.0.tar.gz"
  sha256 "774032006128a896437f5913e132aa27dbfb937cd8847e449522d5a12d63d03e"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url "https://www.rsyslog.com/downloads/download-v8-stable/"
    regex(/href=.*?rsyslog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "f4870a6faba469a138a4c99aebff2abfbffd6d7586983c37202cee040d9df2f5"
    sha256 arm64_ventura:  "35e05d70db97b8fd3be6bb5dbbd5a3ef934aa379ca45b32a81b1442799c08da9"
    sha256 arm64_monterey: "f887391f6e8b0b60ad8fa83da33ff11f92bf3cae23d0b78c27172e3f2b877459"
    sha256 sonoma:         "a20430184242a7d49cb2f02d1203d0ba121be8f58c1fd06beda38fc68ab25c67"
    sha256 ventura:        "c48512f527aa601214707434e148431294261e73b75c5747eefe5d7a164b44ad"
    sha256 monterey:       "d6f1a51adf6e9fee39fcac1e5a88d67e2478c7027a122d3a0120b19ffbf30650"
    sha256 x86_64_linux:   "80843b03b0578be7f6c84aec1d427d009757770fef995ec8bf95eea270a07935"
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
