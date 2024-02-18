class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.6.0/syslog-ng-4.6.0.tar.gz"
  sha256 "b69e3360dfb96a754a4e1cbead4daef37128b1152a23572356db4ab64a475d4f"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  bottle do
    sha256 arm64_sonoma:   "19578e6b6f382c326b6fb8c4d3cd09ec7f55a78e90ae4776fbbfdec81833c8ca"
    sha256 arm64_ventura:  "a0c705a7b53386f97cf4e71c7fd392f5875c9363a9d0e58621e24c36f1191106"
    sha256 arm64_monterey: "c366d1c99deddbe312e6ca672744a2382e894c72c7c6ca0fd0ede33579486b7c"
    sha256 sonoma:         "f616a82c15c8a71cb7c6d1201a5e25c84c3971f7637560768656b6129b4871d9"
    sha256 ventura:        "e3d562b92be1e943d4ac7d6c8560db27fba6e14e2393475a8de5815de99eaa2b"
    sha256 monterey:       "6412eb3a4676aa8160be43e759fbfafb7097d3429ec33aea4de1884e4d09fb97"
    sha256 x86_64_linux:   "c88bbb6dfd93353e59b09b286082c6af3b56527d80da7adab87c487c4d6ced89"
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
  depends_on "pcre2"
  depends_on "python@3.12"
  depends_on "riemann-client"

  uses_from_macos "curl"

  def install
    # In file included from /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include/c++/v1/compare:157:
    # ./version:1:1: error: expected unqualified-id
    rm "VERSION"
    ENV["VERSION"] = version

    python3 = "python3.12"
    sng_python_ver = Language::Python.major_minor_version python3

    venv_path = libexec/"python-venv"
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--sysconfdir=#{pkgetc}",
                          "--localstatedir=#{var}/#{name}",
                          "--with-ivykis=system",
                          "--with-python=#{sng_python_ver}",
                          "--with-python-venv-dir=#{venv_path}",
                          "--disable-afsnmp",
                          "--disable-example-modules",
                          "--disable-java",
                          "--disable-java-modules"
    system "make", "install"

    requirements = lib/"syslog-ng/python/requirements.txt"
    venv = virtualenv_create(venv_path, python3)
    venv.pip_install requirements.read.gsub(/#.*$/, "")
    cp requirements, venv_path
  end

  test do
    assert_equal "syslog-ng #{version.major} (#{version})",
                 shell_output("#{sbin}/syslog-ng --version").lines.first.chomp
    system "#{sbin}/syslog-ng", "--cfgfile=#{pkgetc}/syslog-ng.conf", "--syntax-only"
  end
end
