class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.8.1/syslog-ng-4.8.1.tar.gz"
  sha256 "e8b8b98c60a5b68b25e3462c4104c35d05b975e6778d38d8a81b8ff7c0e64c5b"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 11
  head "https://github.com/syslog-ng/syslog-ng.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "f9d3153c7005b8a2ddaf4466adae5150e3bf01ddd4ff49096a114b7c25f86c2e"
    sha256 arm64_sonoma:  "70141a889e0a979aa13740b002f6a6506e2f12bc804b30b8380e63731f1e978e"
    sha256 arm64_ventura: "02415e1f6a326c551e3a27bf54ce1c74084a716a2050c9c4bc3d91f4786667ff"
    sha256 sonoma:        "40ae4d1813ed95e00355a6f5d18bbd0b479531cb5776568f16df563367b44a72"
    sha256 ventura:       "9e6125aab5f120cddd9b57cb54be53129632869f2205716ce1c4fc951e154d50"
    sha256 x86_64_linux:  "b4db8d31ca3da84459e5f6c1eebc60394e9ebe0e083379fae67f8d523d08a9b9"
  end

  depends_on "pkgconf" => :build

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

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV["VERSION"] = version

    python3 = "python3.12"
    venv = virtualenv_create(libexec, python3)
    # FIXME: we should use resource blocks but there is no upstream pip support besides this requirements.txt
    # https://github.com/syslog-ng/syslog-ng/blob/master/requirements.txt
    args = std_pip_args(prefix: false, build_isolation: true).reject { |s| s["--no-deps"] }
    system python3, "-m", "pip", "--python=#{venv.root}/bin/python",
                          "install", *args, "--requirement=#{buildpath}/requirements.txt"

    system "./configure", *std_configure_args,
                          "CXXFLAGS=-std=c++17",
                          "--disable-silent-rules",
                          "--enable-all-modules",
                          "--sysconfdir=#{pkgetc}",
                          "--localstatedir=#{var/name}",
                          "--with-ivykis=system",
                          "--with-python=#{Language::Python.major_minor_version python3}",
                          "--with-python-venv-dir=#{venv.root}",
                          "--disable-example-modules",
                          "--disable-java",
                          "--disable-java-modules",
                          "--disable-smtp"
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}/syslog-ng --version")
    assert_equal "syslog-ng #{version.major} (#{version})", output.lines.first.chomp
    system sbin/"syslog-ng", "--cfgfile=#{pkgetc}/syslog-ng.conf", "--syntax-only"
  end
end
