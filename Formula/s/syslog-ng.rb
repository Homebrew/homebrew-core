class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.10.2/syslog-ng-4.10.2.tar.gz"
  sha256 "841503de6c2486e66fd08f0c62ac2568fc8ed1021297f855e8acd58ad7caff76"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://github.com/syslog-ng/syslog-ng.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "da5a97edda8f30f14529bfec6fc51ca7949b5c6096ed4f96356b16dc16a561f9"
    sha256 arm64_sequoia: "1d58af1772fed0efa2c5dfdbfbcba82220f42b6f35f6a4c87b770dee155f5437"
    sha256 arm64_sonoma:  "36e76743940c364a48c391f389aee95fcf7b7d642cd2b914b7d8a6e04a04b4d6"
    sha256 sonoma:        "6ace88bf509ea294d4492ec75768059de9e4b65947c82272bc315daf51fd001d"
    sha256 arm64_linux:   "0fb65be2ba5c86ca706c899a32bbd171fc346cc50dabdcac61fdb5b9f85ce440"
    sha256 x86_64_linux:  "0bcc8a1fad98a2a09a703875c8544a428c2e415db2d0bd36e68629330340f291"
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
