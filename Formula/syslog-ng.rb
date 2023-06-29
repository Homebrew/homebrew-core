class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.2.0/syslog-ng-4.2.0.tar.gz"
  sha256 "092bd17fd47002c988aebdf81d0ed3f3cfd0e82b388d2453bcaa5e67934f4dda"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  bottle do
    sha256 arm64_ventura:  "04b7082d340dd4533abeaf0e1dca10f1d22a0d5152cf68e5345b4685746a1073"
    sha256 arm64_monterey: "d30a5a38e3a439c74c4c5b686c59a4ac22a1e2da6ba3376cf1f64acd4872e5aa"
    sha256 arm64_big_sur:  "768b91c0531c8b2060c24155f420746208ef1a13d0bd445455365ab1646cf328"
    sha256 ventura:        "da0745ce188b60e9f00f85080413ac61ddfff4ab0397e0b8acdc9adc494aaa03"
    sha256 monterey:       "1c7a64be94bee2326420642a086cbad728ecfc3a100ea6f8e180b872e5d48bee"
    sha256 big_sur:        "66523fb7b93a1805af3630713cbc4987e05795b2f1183a63ab62c9ea30a67764"
    sha256 x86_64_linux:   "096f15f3f1b72d8ee9022d76288b62ca3ac958866d2394b4bea9ffea42fd6547"
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
  depends_on "openssl@3"
  depends_on "pcre"
  depends_on "python@3.11"
  depends_on "riemann-client"

  uses_from_macos "curl"

  def install
    sng_python_ver = Formula["python@3.11"].version.major_minor

    venv_path = libexec/"python-venv"
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--sysconfdir=#{pkgetc}",
                          "--localstatedir=#{var}/#{name}",
                          "--with-ivykis=system",
                          "--with-python=#{sng_python_ver}",
                          "--with-python-venv-dir=#{venv_path}",
                          "--disable-afsnmp",
                          "--disable-java",
                          "--disable-java-modules"
    system "make", "install"

    requirements = lib/"syslog-ng/python/requirements.txt"
    venv = virtualenv_create(venv_path, "python3.11")
    venv.pip_install requirements.read
    cp requirements, venv_path
  end

  test do
    system "#{sbin}/syslog-ng", "--version"
    system "#{sbin}/syslog-ng", "--cfgfile=#{pkgetc}/syslog-ng.conf", "--syntax-only"
  end
end
