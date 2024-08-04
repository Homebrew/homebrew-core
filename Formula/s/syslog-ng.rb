class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.8.0/syslog-ng-4.8.0.tar.gz"
  sha256 "f2035546af5fcc0c03a8d03f5f0e929ce19131a428d611c982a5fea608a5d9d6"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 3
  head "https://github.com/syslog-ng/syslog-ng.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "be72929013d40ef8b362da2c348c3bcd6cc6f9c3576e06e4927ad77cf07d1608"
    sha256 arm64_ventura:  "e8ca17a0af89400153f23c2c3379909717c977b49c1e40e4c899b6be051520eb"
    sha256 arm64_monterey: "398c454f8be6a3c0f6a9291bbe1636c933632af48119122023a7c67c1824b28a"
    sha256 sonoma:         "12c59c8390ec2c634ef6a5a7de646e63c06900790dc9d3e1b1ee2784cb66541e"
    sha256 ventura:        "4eda946b58e2b5202a68b14a356e8f41bc894d5881d7ea990d2c8a36af974eff"
    sha256 monterey:       "6c9635e31c1a5deee3a0c9e29ce268faf16bbd3541410eddedd358e2409eb5a8"
    sha256 x86_64_linux:   "95613dc27d4a988e69e01c9d0fcd36fca5150a0829673ac1718dac59e2e21571"
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

  on_macos do
    depends_on "gettext"
  end

  def install
    # In file included from /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include/c++/v1/compare:157:
    # ./version:1:1: error: expected unqualified-id
    rm "VERSION"
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
                          "--localstatedir=#{var}/#{name}",
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
