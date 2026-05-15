class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.11.0/syslog-ng-4.11.0.tar.gz"
  sha256 "37ea0d4588533316de122df4e1b249867b0a0575f646c7478d0cc4d747462943"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 4
  head "https://github.com/syslog-ng/syslog-ng.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "bf8103b3948084c9ee20689d056df70370c0e65609caed961f7d31e8380a8a78"
    sha256 arm64_sequoia: "171d112af4bde4df1a02fc8a757538a3b7dddcb0fb9afbbf66b03a10b94470bd"
    sha256 arm64_sonoma:  "a859325d43eb76bb54552a08f184663587601e1aba084502c5eea63e3a470181"
    sha256 sonoma:        "992aa131bab9c4b95ad94dfdc769bc2fc92e7aa022967ba1b3143dab9349acee"
    sha256 arm64_linux:   "f1460fc2a4b3251b23c0685f739d3f0200b0a96a7ee14782d4752021997721c7"
    sha256 x86_64_linux:  "89119f25bb0d0dc80201c0121f5b90a46dacd28d6dd0dc995364a3bb84c2665b"
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

    python3 = "python3.14"
    venv = virtualenv_create(libexec, python3)
    # FIXME: we should use resource blocks but there is no upstream pip support besides this requirements.txt
    # https://github.com/syslog-ng/syslog-ng/blob/master/requirements.txt
    args = std_pip_args(prefix: false, build_isolation: true).reject { |s| s["--no-deps"] }
    system python3, "-m", "pip", "--python=#{venv.root}/bin/python",
                          "install", *args, "--requirement=#{buildpath}/requirements.txt"

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
