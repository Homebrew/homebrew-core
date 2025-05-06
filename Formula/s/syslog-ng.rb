class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.8.1/syslog-ng-4.8.1.tar.gz"
  sha256 "e8b8b98c60a5b68b25e3462c4104c35d05b975e6778d38d8a81b8ff7c0e64c5b"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 12
  head "https://github.com/syslog-ng/syslog-ng.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "bb698ed0b7dcf3e503c7a955d94b70e1efc80ee89dcecd2ed7be418d9a9c18dd"
    sha256 arm64_sonoma:  "d3a9688396c9be181b83dfd04f09dad7c745a13d312ce5a9c6127987b627f4ff"
    sha256 arm64_ventura: "bb1641bd45a0b536e48b83f9e02a5a0a35a1baf6bc74d5cfd14cb0f08efbdc11"
    sha256 sonoma:        "a0ec3a498c3df9563fa91b6809f9b44eaf5acce4f1c41e0d51b0476b679cb57c"
    sha256 ventura:       "bf10a02dd697ae556a4dc5efd58b4a50d8285f84cff2c9693af7c9a6c2c96d14"
    sha256 arm64_linux:   "2f83b1817ac7a1d0c5380ed6fc10f9cd367ffcbb51747e71300a4617a3882cbd"
    sha256 x86_64_linux:  "c7cff8e38c75625c4953d27367ba7341f015e282a3d7608c9d72140a360fef9a"
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
