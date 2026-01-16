class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.10.1/syslog-ng-4.10.1.tar.gz"
  sha256 "dea90cf1dc4b8674ff191e0032f9dabc24b291abfd7f110fd092ae5f21cde5d7"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 7
  head "https://github.com/syslog-ng/syslog-ng.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "ea744bd92cf8a6018247cf4536d8c7ae6ccdef86a15bc62d7024316a435741a6"
    sha256 arm64_sequoia: "8331194b350670a7ced54109c7fb5494bcdaa25d8dfaa8f5a878c5f4d5a91dbc"
    sha256 arm64_sonoma:  "11e6ae36c8f208106abc7534a98a8cc9c9d2adba8bc7911085261dc84dc95bda"
    sha256 sonoma:        "ea133fade1f431167b1526294d82ede13c425d6241f23a776ed3e08a316bc523"
    sha256 arm64_linux:   "6853fbdf1b12f40195cd464cc12f414d4f66262e1b1805abe390c98268dc263b"
    sha256 x86_64_linux:  "813c1bff89c7b0952b0feb0de54f6e6fe6492e6d4d65de23dc72e569e296f4dd"
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
