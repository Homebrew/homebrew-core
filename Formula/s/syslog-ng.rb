class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.8.3/syslog-ng-4.8.3.tar.gz"
  sha256 "f82732a8e639373037d2b69c0e6d5d6594290f0350350f7a146af4cd8ab9e2c7"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 2
  head "https://github.com/syslog-ng/syslog-ng.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "a0dd2aa906edf808365589337925346294631afaa3a72884a67af81e6bc9b9e1"
    sha256 arm64_sonoma:  "8f3d14f563daf5c81f9126b50d78c3e97009c160b66c81c8683ea393ecfde715"
    sha256 arm64_ventura: "503dc684479b26464528269d3537f4de4537caf0dc5820709ace2994dcd25e4d"
    sha256 sonoma:        "05c5019780e23ed7cb7aba1a16f5066c379c446c55a97023b6cecf8ed403aa54"
    sha256 ventura:       "b165340eb625f85e1a7e7093b7f3633d078b36ea97bb7c78ea6b7309888f1467"
    sha256 arm64_linux:   "c0c8e1bbc13b0c1372bb6fb04d89c3bcd360550765db5efb3ea1dc08836e9ad6"
    sha256 x86_64_linux:  "7910edc406a5d90d96e962932d651ab6cb4f876d6dd5416abee812f3e1a8c40f"
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
