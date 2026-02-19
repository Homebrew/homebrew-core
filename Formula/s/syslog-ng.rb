class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 1
  head "https://github.com/syslog-ng/syslog-ng.git", branch: "develop"

  stable do
    url "https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.10.2/syslog-ng-4.10.2.tar.gz"
    sha256 "841503de6c2486e66fd08f0c62ac2568fc8ed1021297f855e8acd58ad7caff76"

    # Backport Python dependency updates to avoid vulnerable packages
    patch do
      url "https://github.com/syslog-ng/syslog-ng/commit/89c1dcfb411e3c5611629fe99561f3106eb19b0f.patch?full_index=1"
      sha256 "eb42508fa0a1b716ef8967151f10fe86b427e21fc50ef2f160c14bbd35a89291"
    end
    patch do
      url "https://github.com/syslog-ng/syslog-ng/commit/dc070981e726ca1babb8e48bc368d0429eac9223.patch?full_index=1"
      sha256 "1d7bb9994f0aff742fec24a038df90d199fa2e43aae28a396dc51a892fe7a95b"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "83f4f02c60b04ad1436a9c880088632b9dea01b90ecc752e36d29e8ee7c4445d"
    sha256 arm64_sequoia: "8eace38656103e1fb3f36bd98450bd097424645e82045dd7f81989488868c51c"
    sha256 arm64_sonoma:  "9bccf4f0a4f4382bedf8e4d7db712c6e9be88907e4023674f36cddf0e0d19bd5"
    sha256 sonoma:        "b87c62c80bc837a4fa18ac4aaad75cd4a3d35904705ae3f75058fd2fff23dc26"
    sha256 arm64_linux:   "1285001349fef143798a9276f085cd3aa5f004ef3aad7d422526e4cc8e49d408"
    sha256 x86_64_linux:  "e7218c309918d694c1889fa18d593ef9cce3716208fac52476f5cfef00b3ab22"
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
