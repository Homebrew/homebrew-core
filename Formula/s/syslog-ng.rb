class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.10.1/syslog-ng-4.10.1.tar.gz"
  sha256 "dea90cf1dc4b8674ff191e0032f9dabc24b291abfd7f110fd092ae5f21cde5d7"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 3
  head "https://github.com/syslog-ng/syslog-ng.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "de321c8629d5063aebf2bd17f7112ac08b7a7082cb6b329b4e645623dfdeb214"
    sha256 arm64_sequoia: "cd73472808d144299ea6f756a606f8774b2db6c4075443db732e5066af1921a0"
    sha256 arm64_sonoma:  "293fd9077af989210279585230ccfb74fe120cdae4e9af743d50883ce445bca6"
    sha256 sonoma:        "e2ed2980c24562ebdd85ca9ff6b7a605351f544248e72dc26ba5ce33e6bdc566"
    sha256 arm64_linux:   "626af44535225d386ef4de41a121d3cba7916568759aa17c86fc2a38558942b4"
    sha256 x86_64_linux:  "74d538f25fbf55d0307f7366e16e8be235e99cebdd569b35ceefab53ae901c75"
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
  depends_on "python@3.14"
  depends_on "rabbitmq-c"
  depends_on "riemann-client"

  uses_from_macos "curl"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV["VERSION"] = version

    # Workaround to allow Python 3.13+
    inreplace "requirements.txt", "PyYAML==6.0.1", "PyYAML==6.0.2"

    python3 = "python3.14"
    venv = virtualenv_create(libexec, python3)
    # FIXME: we should use resource blocks but there is no upstream pip support besides this requirements.txt
    # https://github.com/syslog-ng/syslog-ng/blob/master/requirements.txt
    args = std_pip_args(prefix: false, build_isolation: true).reject { |s| s["--no-deps"] }
    system python3, "-m", "pip", "--python=#{venv.root}/bin/python",
                          "install", *args, "--requirement=#{buildpath}/requirements.txt"

    ENV.append "CXXFLAGS", "-std=c++17"

    system "./configure", "--disable-silent-rules",
                          "--enable-all-modules",
                          "--sysconfdir=#{pkgetc}",
                          "--localstatedir=#{var/name}",
                          "--with-ivykis=system",
                          "--with-python=#{Language::Python.major_minor_version python3}",
                          "--with-python-venv-dir=#{venv.root}",
                          "--disable-example-modules",
                          "--disable-java",
                          "--disable-java-modules",
                          "--disable-smtp",
                          *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}/syslog-ng --version")
    assert_equal "syslog-ng #{version.major} (#{version})", output.lines.first.chomp
    system sbin/"syslog-ng", "--cfgfile=#{pkgetc}/syslog-ng.conf", "--syntax-only"
  end
end
