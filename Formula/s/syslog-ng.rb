class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.2.0/syslog-ng-4.2.0.tar.gz"
  sha256 "092bd17fd47002c988aebdf81d0ed3f3cfd0e82b388d2453bcaa5e67934f4dda"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 1

  bottle do
    sha256 arm64_ventura:  "4ef97eb024a908a39221bfecee23ed2578b3846c12e62b31004feeeffddf7456"
    sha256 arm64_monterey: "fe3bcb50386bd8920f3a65b161d0300bb16f212a024cc67c664d2289dacf4971"
    sha256 arm64_big_sur:  "de9817a4897edd2784b052ea4522b8a0eadaf6412a325c190eebb221db42d630"
    sha256 ventura:        "eb0c417c37cd153382100bc7941a305db19b1264bd003472fc74465b0d5d41c9"
    sha256 monterey:       "ad846597fded4dc7bb58fc75403b3480ad113f2d55dfb3288b0ca76c459bfba8"
    sha256 big_sur:        "9b38e7118f424020b318f7c917fc627adc145ceefb3c93e7a38190d45c0901d0"
    sha256 x86_64_linux:   "169cb8db5df8ddc1298f6fed1ffa639cab1d68c70b5eaab0d554c4a5c77e40cd"
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

  # patch pyyaml build, remove in next release
  # relates to https://github.com/yaml/pyyaml/pull/702
  patch do
    url "https://github.com/syslog-ng/syslog-ng/commit/246dc5c8425b15a0a1ab0229e44e52f5c0aebe2c.patch?full_index=1"
    sha256 "7e75103fdeb54c185342d1dce2dc7a215c2d6812be15c5199ce480a62e2a05bf"
  end

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
