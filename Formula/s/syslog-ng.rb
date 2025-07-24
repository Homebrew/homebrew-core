class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.9.0/syslog-ng-4.9.0.tar.gz"
  sha256 "6959545cb9aaa694e4514f472c69d6e5a908abb5161861a0082c917cdf7184e2"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 1
  head "https://github.com/syslog-ng/syslog-ng.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "76ca989b0c3b121e1950b8457998a7d1df5d17b47a902d260154da8c3f180fa5"
    sha256 arm64_sonoma:  "0bbc703ea9d52216e54270dcfc3e85efc1262780d05491b4675597f4bc02e2a7"
    sha256 arm64_ventura: "b33db89586b51982bcf3c7d907efaae3394a714a708f2b5d984f4b5d4698b752"
    sha256 sonoma:        "9cf79032d04f113c8c581d3b7921d16bce460990ddbaeedd16fb7ae8c22e4bb5"
    sha256 ventura:       "1c8d1c6acfa6bc19b59e9e0083a01ac91eb9d0a12d87c2d32c00b82b7e5ba401"
    sha256 arm64_linux:   "3bf75625fda0cf8f31a78714fd7d9cc30370e81169e8d99eea1b757abf64d51d"
    sha256 x86_64_linux:  "6f5fd1b833ad7f9a43d4800ff49e95bc455e4cdcb6a264eff786071d6b21721b"
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
  depends_on "mongo-c-driver@1"
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
