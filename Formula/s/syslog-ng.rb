class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.9.0/syslog-ng-4.9.0.tar.gz"
  sha256 "6959545cb9aaa694e4514f472c69d6e5a908abb5161861a0082c917cdf7184e2"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 3
  head "https://github.com/syslog-ng/syslog-ng.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "1e99a4528b1f93ec77438b257f45349073a246460ddfb92ef119b1d07d1e8a2e"
    sha256 arm64_sonoma:  "d6f4f8e100a8fd381d27d71f2a97030f45860ba0a0719dd35a766223bfa1a357"
    sha256 arm64_ventura: "ba122d96eee59234165dbbb1db1985588d914596ae78800ca3903007addb35c3"
    sha256 sonoma:        "2b3440133e576247d9604497503acb7438d749b98adabc5b175b712ffb2ae6b9"
    sha256 ventura:       "e6f988d9949eb5b77e56ab0bfa74aef6cb8e79ce588fb0e58ed3144d7ad220a5"
    sha256 arm64_linux:   "792cbdc579c62351483fea7c206a37efd384e944f47943c7df2b8b198f0ab465"
    sha256 x86_64_linux:  "e5fde895a449cfe14ce690b591386824b2812cfc11a10587be1f07f37897e90d"
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
