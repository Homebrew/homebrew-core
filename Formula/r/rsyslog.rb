class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.2412.0.tar.gz"
  sha256 "8cdfa5a077cba576bdd6b1841cc2848b774e663b2e44a39512bb820174174802"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url "https://www.rsyslog.com/downloads/download-v8-stable/"
    regex(/href=.*?rsyslog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "a6bdd3c313df1e78f07ad1c17d10ad789fcf81fe36a086e20205f5a7e776e9f0"
    sha256 arm64_sonoma:  "354d633feb5a36805573f10f8e1c3fcc5f608ffc5026212635047b346b3e197a"
    sha256 arm64_ventura: "7ea98249ad0dc1e7a4597e7057f5c6876242a249309b9cc49324be1e7e3e4e59"
    sha256 sonoma:        "634fdc7ce73d23b03242f48159487efb0b5c4fc260969ecc714efde9420ba2b1"
    sha256 ventura:       "d062e44b88e5d1b02ffab7237dac1a70fef11e1a204137ffb4a4284123ceddd1"
    sha256 arm64_linux:   "8bf6e7b74eb77f2caabf141e907132cd9dd3ea91a77c0a91ef10adda9e2baab7"
    sha256 x86_64_linux:  "b0f6a768aa0755c58ca09703551430588f40df0273679bc4131bdda4bc508c73"
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "libestr"
  depends_on "libfastjson"

  uses_from_macos "curl"
  uses_from_macos "zlib"

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

    (buildpath/"rsyslog.conf").write <<~EOS
      # minimal config file for receiving logs over UDP port 10514
      $ModLoad imudp
      $UDPServerRun 10514
      *.* /usr/local/var/log/rsyslog-remote.log
    EOS
    etc.install buildpath/"rsyslog.conf"
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
