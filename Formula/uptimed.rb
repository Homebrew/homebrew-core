class Uptimed < Formula
  desc "Utility to track your highest uptimes"
  homepage "https://github.com/rpodgorny/uptimed/"
  url "https://github.com/rpodgorny/uptimed/archive/v0.4.4.tar.gz"
  sha256 "041f59710c316c68907e9bd07db2606f3dc16bee908b5644715ff2be30c59453"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "4e1ae62985ae67f3733325ee8c87c8aafcc3702f58d8e97257eaca2c19367e96"
    sha256 cellar: :any,                 big_sur:       "a7b8ccdc3076867427de19187190942d9403468a6d793de109d1207f9dab873e"
    sha256 cellar: :any,                 catalina:      "8c30d6732c2ce84262b94e38df3a6eaa6a9412d7a35faff593167fb5cdec8450"
    sha256 cellar: :any,                 mojave:        "309c440655a5166596facdcbcdd2035fd7fa5a6b1263f4bd10a8d1aa1be612b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd27de8d758ab4c321995dcef58b156ecd302e70089bc6aa6e14bb802d8cb177"
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
