class Uptimed < Formula
  desc "Utility to track your highest uptimes"
  homepage "https://github.com/rpodgorny/uptimed/"
  url "https://github.com/rpodgorny/uptimed/archive/v0.4.3.tar.gz"
  sha256 "11add61c39cb2a50f604266104c5ceb291ab830939ed7c84659c309be1e1e715"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "8efbddfdb0eef471f4d0f50a55cf791d422d918d1a4f10b68e8383f7408caa08"
    sha256 cellar: :any,                 big_sur:       "fc45435953f14fc7a182884dfa4e2672213c71675c9e73fb6a3799a140e66caa"
    sha256 cellar: :any,                 catalina:      "1e20c4955ff14a05da57be77e08e163e164e41995411c21aeaa5a5bf3919fb7c"
    sha256 cellar: :any,                 mojave:        "d5d96957debd223a243d71dc0d9858d19179c94841f6640822b1db841c0bfd48"
    sha256 cellar: :any,                 high_sierra:   "8585595184bf697772b292e123f63c97513e242c7d04194c9e1990d60fcef571"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ddcee77c17f262b3ec8aaa7a71472fba2b76d328ccb2d0e3aa2a2ea35ab7732"
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
