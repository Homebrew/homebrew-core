class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.11.0/syslog-ng-4.11.0.tar.gz"
  sha256 "37ea0d4588533316de122df4e1b249867b0a0575f646c7478d0cc4d747462943"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 2
  head "https://github.com/syslog-ng/syslog-ng.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "c52c4993b8d94ad310b3f8813c3c389b0dbb1b8804c3289254cebfdaf49d78eb"
    sha256 arm64_sequoia: "e295c297d47d547dcdca31be4a5d60d90c8a9a6e07f0f3c817f33a03b9230067"
    sha256 arm64_sonoma:  "422e63158a8112bece9a452a5f39c6486b0807a65ab964560b28c3b639179d9e"
    sha256 sonoma:        "4b86836967bbc00d1da57b1f5d2f003f92087493b29ec865eeae03c0373d0a68"
    sha256 arm64_linux:   "e2673221bdbceccf122e2a43edcad4326d1d985c77e8ae4871197b367e99370a"
    sha256 x86_64_linux:  "76f30dc02f912647bcc3dd6c1fd0a5499c18be83aa9ac106a2995e1eccf674fc"
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
