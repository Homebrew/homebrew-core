class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.2308.0.tar.gz"
  sha256 "02086b9121e872cea69e5d0f6c8e2d8ebff33234b3cad5503665378d3af2e3c9"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url "https://www.rsyslog.com/downloads/download-v8-stable/"
    regex(/href=.*?rsyslog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "d85b09d3aac21868a80e98aefeb675cc4f060b5fe7bff5bba90b9b17eae0bc3b"
    sha256 arm64_monterey: "6ba787410cf0c9c877039a3611e489f9d0e505e71352df5d4271ae5610adbcb6"
    sha256 arm64_big_sur:  "6003fac67721d9a82dd971be554f4103c412f0274f9d9b4ced2c4247c6d03976"
    sha256 ventura:        "61b11d0096c49b3e130ebc7329a556be953600bbb74deab2505482870f65d1b3"
    sha256 monterey:       "1d3a0d7dd1b262c1b9ad2695b53ed7faeaf2605bf24741ce4654e1dd502f1d16"
    sha256 big_sur:        "d1ed3e1757c9e9e89db4fe334df2d0283edf435d22f57710734b9e44a1042be5"
    sha256 x86_64_linux:   "fd9c16ad3c3d7762b4edc72813a8f90fb45d5a7f0ae94ceec2efeb4d38e6d5da"
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
