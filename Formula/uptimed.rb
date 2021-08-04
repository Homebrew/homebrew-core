class Uptimed < Formula
  desc "Utility to track your highest uptimes"
  homepage "https://github.com/rpodgorny/uptimed/"
  url "https://github.com/rpodgorny/uptimed/archive/v0.4.4.tar.gz"
  sha256 "041f59710c316c68907e9bd07db2606f3dc16bee908b5644715ff2be30c59453"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "3bf60bc86d6e026496d8e576b5fec6bf863b6c247f73c8b168120277cd8aedac"
    sha256 cellar: :any,                 big_sur:       "692c1896e82820e296004bc510cc368221528914f93b8e178041fb06399c7473"
    sha256 cellar: :any,                 catalina:      "5549cf3cf61a32a71c6258108317d3a779aca1b23d7ac7a714cbf5db5ca233af"
    sha256 cellar: :any,                 mojave:        "8e63ad1975e1d8d36adbe624228441b07c6acbbf144e2d0a66fd76cc168b5d8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84b78ecf328840104126dd6e69da148c4d5eea9b1b46a01b9b4d1fff1b189dfb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # Per MacPorts
    inreplace "Makefile", "/var/spool/uptimed", "#{var}/uptimed"
    inreplace "libuptimed/urec.h", "/var/spool", var
    inreplace "etc/uptimed.conf-dist", "/var/run", "#{var}/uptimed"
    system "make", "install"
  end

  service do
    run [opt_sbin/"uptimed", "-f", "-p", var/"run/uptimed.pid"]
    keep_alive false
    working_dir opt_prefix
  end

  test do
    system "#{sbin}/uptimed", "-t", "0"
    sleep 2
    output = shell_output("#{bin}/uprecords -s")
    assert_match(/->\s+\d+\s+\d+\w,\s+\d+:\d+:\d+\s+|.*/, output, "Uptime returned is invalid")
  end
end
