class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.12.0/syslog-ng-4.12.0.tar.gz"
  sha256 "03a03d19ac203dca53c7ec79a7005c8a850665a95ff4cd0f1e7bb4c497c64d46"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 12
  head "https://github.com/syslog-ng/syslog-ng.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "e50fc4d068cdb7c5b6d95793039291d9ddf9047ac60b82d1e574e2ba3614dd26"
    sha256 arm64_tahoe:       "97a4403efb6da8c3961b7d6d91002160525821d383591a016eb633688f729ada"
    sha256 arm64_sequoia:     "734676801cbab5a81742db4b75c27fb80d1704ac33bfd29564a8a81fa6ced685"
    sha256 arm64_linux:       "57d85d87ff54d2854181b0a14e5c432e8b12466b6f581a768007dea3f2060867"
    sha256 x86_64_linux:      "53acf685baf1de4f1c7ca04c9068b0675ff50679501a3b926b46abd3c05161d7"
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

    # Drop `-no-undefined` so modules resolve core symbols at load time; remove in next release.
    # macOS-only: `autoreconf` only runs there and the mtime bump breaks the Linux dist build.
    patch do
      url "https://github.com/syslog-ng/syslog-ng/commit/97e2a3e5281af6fab88354bc2cc408bfb662c3c6.patch?full_index=1"
      sha256 "112d45c528ab9c872b81444d2aa1e5b0bd88c65244583ee38cf172cee50f0338"
      type :backport
      resolves "https://github.com/syslog-ng/syslog-ng/pull/5743"
    end
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
