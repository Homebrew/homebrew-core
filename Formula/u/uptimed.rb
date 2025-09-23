class Uptimed < Formula
  desc "Utility to track your highest uptimes"
  homepage "https://github.com/rpodgorny/uptimed/"
  url "https://github.com/rpodgorny/uptimed/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "2f669d2968ca1d0865b7a97791c9dbcca759631a1afc5d6702964f070a57252b"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1a4da6e33e3e7435bc5113e5188a66010b6040ca93d94516083b81c58b054141"
    sha256 cellar: :any,                 arm64_sequoia: "ee7bb2f7dc9f48106feb78d76476b6adc63ac69234e0b09e4a032479175aac45"
    sha256 cellar: :any,                 arm64_sonoma:  "306897fc0a7d58890bd55d642505888b4989db7017b4ddfd1ba0af603ed5365e"
    sha256 cellar: :any,                 arm64_ventura: "c026d07897983b4e7f7f07ceb14d77aeea163b8c3d26bfbdc2e7e3f5a5b2ed56"
    sha256 cellar: :any,                 sonoma:        "cfdfb6af9480fc37d99d5bdf24f213de9d42fa5ed907019bd020119a26149b8a"
    sha256 cellar: :any,                 ventura:       "c7cf1dd6683a839238be3ff06ae5289bde6e97e0a5594d3d3c1f14c8decf0dd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08296a599456611026d0242ac0946327fb2c004de2e3f5217af4fa14eabc5348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63fe05bdf7bb27772273516a7d3886a2a196c5fd78487805ff1b57db150ef784"
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
