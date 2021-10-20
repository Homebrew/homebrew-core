class Uptimed < Formula
  desc "Utility to track your highest uptimes"
  homepage "https://github.com/rpodgorny/uptimed/"
  url "https://github.com/rpodgorny/uptimed/archive/v0.4.5.tar.gz"
  sha256 "a70806104079bb8b732c5125b63ccf4f62079b9542c01b2a6dc67c50abae123c"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "8e10469d40e946233d7344ba6ad7f61a0020c8cc1f219fcdccdb14b1b7ff4b6f"
    sha256 cellar: :any,                 big_sur:       "2aedccdc024f39c0987a7122a1e5d7e6475e5135f271ba13fd8aa2db9942bd61"
    sha256 cellar: :any,                 catalina:      "2880bb023c91fba97db880872b72e40f5aa3b9c67436f2e8564bfb5d7f07295a"
    sha256 cellar: :any,                 mojave:        "1831d62db8df2e43799b9ddb07174718ddefc3be5271e6723df85efc74664a56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d2dcaf056c5eefdded7bea43720ac7836651625082d9d607484afabbe23acd7"
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
