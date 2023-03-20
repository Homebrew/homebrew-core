class SyslogNg < Formula
  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.1.1/syslog-ng-4.1.1.tar.gz"
  sha256 "d7df3cfa32d1a750818d94b8ea582dea54c37226e7b55a88c3d2f3a543d8f20e"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  bottle do
    sha256 arm64_ventura:  "16bf633f59ad036d6e650158fb59117c550343eb58d466b0d040f882265c8ba8"
    sha256 arm64_monterey: "14ccb4f5c314f9ede695ebe9111a00a0586f78727238cd8ad73f0d5b68f07ec6"
    sha256 arm64_big_sur:  "709b699daef970fd6ccb402bdc26cfec4ab9b7fb3788229aed020e2f472c0700"
    sha256 ventura:        "a9f44d1b0c7b4aaa16afe94010adb12161b1f55a67b082fdf54f42fc57dbfd7c"
    sha256 monterey:       "e3220609629c1fccf365c5fefc4ffb27d599752bafc0c07e5959009678569054"
    sha256 big_sur:        "1ad45ff8d5203d8840c3ee6c89eea51c966ed66a79e7d2538d617a0e04054fcf"
    sha256 x86_64_linux:   "d39f3a52b0231ecb5dcc63d4ae61f912bad59a19e430d594bbc481945bb5bac9"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "hiredis"
  depends_on "ivykis"
  depends_on "json-c"
  depends_on "libdbi"
  depends_on "libmaxminddb"
  depends_on "libnet"
  depends_on "librdkafka"
  depends_on "mongo-c-driver"
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "python@3.11"
  depends_on "riemann-client"

  uses_from_macos "curl"

  def install
    sng_python_ver = Formula["python@3.11"].version.major_minor

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--sysconfdir=#{pkgetc}",
                          "--localstatedir=#{var}",
                          "--with-ivykis=system",
                          "--with-python=#{sng_python_ver}",
                          "--disable-afsnmp",
                          "--disable-java",
                          "--disable-java-modules"
    system "make", "install"
  end

  test do
    system "#{sbin}/syslog-ng", "--version"
    system "#{sbin}/syslog-ng", "--cfgfile=#{pkgetc}/syslog-ng.conf", "--syntax-only"
  end
end
