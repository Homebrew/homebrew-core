class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.8.1/syslog-ng-4.8.1.tar.gz"
  sha256 "e8b8b98c60a5b68b25e3462c4104c35d05b975e6778d38d8a81b8ff7c0e64c5b"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 6
  head "https://github.com/syslog-ng/syslog-ng.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "85e2de9815eb659fda16528ed3c0829988ea4a4f4295cb3151a1710a1ae9318d"
    sha256 arm64_sonoma:  "409fb238d2cb374609025c95bd62bc83bccfd48be977e216a9ba2f57995b930d"
    sha256 arm64_ventura: "0042369fa68a1de0743dbe5a1dc52381d8831a7d6c998662cb6cbc2b37c1adf5"
    sha256 sonoma:        "426d19147da303fb0c3a1c6c4986dae0834d579219cf7b384e3e2770ce20ada6"
    sha256 ventura:       "6f69aa278313b477f50d83f0a95f46a2856dd4b0f30bdd23f10446bcf5941a46"
    sha256 x86_64_linux:  "b69cb4c62833aa81900a46f7274f3c344e0bd371ecbdfc672da7a5250354526e"
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
