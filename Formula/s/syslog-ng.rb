class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.7.1/syslog-ng-4.7.1.tar.gz"
  sha256 "5477189a2d12325aa4faebfcf59f5bdd9084234732f0c3ec16dd253847dacf1c"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 1

  bottle do
    sha256 arm64_sonoma:   "00ddc4bfca13ce78ad1cd239a9301f53001eb0cda274066ce8df6b40a21d61a1"
    sha256 arm64_ventura:  "10e01ab94e2262a8a01dae99fb776eea96a2d41614fb36bc5fee24293951aee5"
    sha256 arm64_monterey: "7620a7c1b231ce58c1a2ba392cef60d8c2c63d74a828c4cc9268f5ed1538559e"
    sha256 sonoma:         "b18cb6a6666ee472c9732d8125edfdab8cccdf11a81ccd51ae5ce8733bad7940"
    sha256 ventura:        "4819160183f8f5b9fe125d8748857ba22e1d621ea2b177ec394ac7ab72d1a5f8"
    sha256 monterey:       "a55a7155ca829aa0d75de2c8b54d070d725509a1615fee7f171389c04ab19280"
    sha256 x86_64_linux:   "cbc70738ff261585815d286fd9cce6e43d202cfc2f8f0311933f1a6d76b82c5a"
  end

  depends_on "pkg-config" => :build

  depends_on "abseil"
  depends_on "glib"
  depends_on "grpc"
  depends_on "hiredis"
  depends_on "ivykis"
  depends_on "json-c"
  depends_on "libdbi"
  depends_on "libmaxminddb"
  depends_on "libnet"
  depends_on "libpaho-mqtt"
  depends_on "librdkafka"
  depends_on "mongo-c-driver"
  depends_on "net-snmp"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "protobuf"
  depends_on "python@3.12"
  depends_on "rabbitmq-c"
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
                          "CXXFLAGS=-std=c++17",
                          "--disable-silent-rules",
                          "--enable-all-modules",
                          "--sysconfdir=#{pkgetc}",
                          "--localstatedir=#{var}/#{name}",
                          "--with-ivykis=system",
                          "--with-python=#{sng_python_ver}",
                          "--with-python-venv-dir=#{venv_path}",
                          "--disable-example-modules",
                          "--disable-java",
                          "--disable-java-modules",
                          "--disable-smtp",
                          # enable this after v4.8.0 is released: https://github.com/syslog-ng/syslog-ng/pull/4924
                          "--disable-grpc"
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
