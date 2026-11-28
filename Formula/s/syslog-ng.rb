class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.13.0/syslog-ng-4.13.0.tar.gz"
  sha256 "e82daa3139d1cd790f2d8f2699c70b56a521d8e5218f7e52633dfad1b1f63297"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://github.com/syslog-ng/syslog-ng.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "e3150d0b233b45706ef1a880826703061bf409a06b8201274f970d15b73c5b1d"
    sha256 arm64_golden_gate: "e3fa684eee1c2bfa2d5f7b42f46628913751501575e68f3c83fc502fb34defe5"
    sha256 arm64_tahoe:       "0c86160a2673577c1b3e65e5bb87dd0f6ba50c0c8ac57bf4dd9ce68e038c444e"
    sha256 arm64_sequoia:     "bc7549e2cffd86b72e55e5b4aaf875f474b98e1751be27adeb6dd19c085c0631"
    sha256 arm64_linux:       "81b7c1f5c4cbb2d188ffbef7ce9a0c58f62fdb8b6a5649d83b79aecb8c217f4e"
    sha256 x86_64_linux:      "999c02f14d4e730606579130e1dc5fb32d8ab0dba2993af6083fd1c887d7db64"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build # for kubernetes > pydantic > pydantic-core

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
  depends_on "libyaml"
  depends_on "mongo-c-driver"
  depends_on "net-snmp"
  depends_on "openssl@4"
  depends_on "pcre2"
  depends_on "protobuf"
  depends_on "python@3.15"
  depends_on "rabbitmq-c"
  depends_on "riemann-client"

  uses_from_macos "curl"

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["VERSION"] = version

    # Need to regenerate configure on macOS to avoid undefined symbols, e.g. "_evt_tag_errno"
    system "autoreconf", "--force", "--install", "--verbose" if OS.mac?

    venv = virtualenv_create(libexec, python3)
    # FIXME: we should use resource blocks but there is no upstream pip support besides this requirements.txt
    # https://github.com/syslog-ng/syslog-ng/blob/master/requirements.txt
    args = std_pip_args(prefix: false, build_isolation: true).reject { |s| s["--no-deps"] }
    system python3, "-m", "pip", "--python=#{venv.root}/bin/python",
                          "install", *args, "--requirement=#{buildpath}/requirements.txt"

    system "./configure", "--disable-silent-rules",
                          "--enable-all-modules",
                          "--sysconfdir=#{pkgetc}",
                          "--localstatedir=#{var}/#{name}",
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
