class Trafficserver < Formula
  desc "HTTP/1.1 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  url "https://downloads.apache.org/trafficserver/trafficserver-9.2.1.tar.bz2"
  mirror "https://archive.apache.org/dist/trafficserver/trafficserver-9.2.1.tar.bz2"
  sha256 "c9080a521758f258391ff7ceb99b824bcc652b3fd9125a3580697bb2e5eb43b2"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "3a89e7e8cdf9b043958d59d5e8b95864f6f6bb081210502551ea557f7aa4266a"
    sha256 arm64_monterey: "6294230662c1db435293a0a8e32df00ad125a080f331cb66fd37d0aeaaed9730"
    sha256 arm64_big_sur:  "ca2283b06906400a6f063e25a3dbbcb5c3a1889b1ac5e4d766fcab23be3ea2aa"
    sha256 ventura:        "56279bf0d054a6f12ed0af3eba599f2854e22add255a196aa732c6e6460c3efa"
    sha256 monterey:       "cceadc78b480fb33a9da7462fa7e9149500aaf53aa290bfbc564caf43f13e6cb"
    sha256 big_sur:        "a5eeb644895ae0501d08a8ae84d73305792ce093194d6fac9384cc9f7baeb140"
    sha256 x86_64_linux:   "8635f815f52c6695883857799cf7bff966133ab657bfe275d5b3135874a6ceb8"
  end

  head do
    url "https://github.com/apache/trafficserver.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "pkg-config" => :build
  depends_on "hwloc"
  depends_on macos: :mojave # `error: call to unavailable member function 'value': introduced in macOS 10.14`
  depends_on "openssl@3"
  depends_on "pcre"
  depends_on "yaml-cpp"

  on_macos do
    # Need to regenerate configure to fix macOS 11+ build error due to undefined symbols
    # See https://github.com/apache/trafficserver/pull/8556#issuecomment-995319215
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  fails_with gcc: "5" # needs C++17

  fails_with :clang do
    build 800
    cause "needs C++17"
  end

  def install
    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s

    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --localstatedir=#{var}
      --sysconfdir=#{pkgetc}
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
      --with-yaml-cpp=#{Formula["yaml-cpp"].opt_prefix}
      --with-group=admin
      --disable-tests
      --disable-silent-rules
      --enable-experimental-plugins
    ]

    system "autoreconf", "-fvi" if build.head? || OS.mac?
    system "./configure", *args

    # Fix wrong username in the generated startup script for bottles.
    inreplace "rc/trafficserver.in", "@pkgsysuser@", "$USER"

    inreplace "lib/perl/Makefile",
      "Makefile.PL INSTALLDIRS=$(INSTALLDIRS)",
      "Makefile.PL INSTALLDIRS=$(INSTALLDIRS) INSTALLSITEMAN3DIR=#{man3}"

    system "make" if build.head?
    system "make", "install"
  end

  def post_install
    (var/"log/trafficserver").mkpath
    (var/"trafficserver").mkpath

    config = etc/"trafficserver/records.config"
    return unless File.exist?(config)
    return if File.read(config).include?("proxy.config.admin.user_id STRING #{ENV["USER"]}")

    config.append_lines "CONFIG proxy.config.admin.user_id STRING #{ENV["USER"]}"
  end

  test do
    if OS.mac?
      output = shell_output("#{bin}/trafficserver status")
      assert_match "Apache Traffic Server is not running", output
    else
      output = shell_output("#{bin}/trafficserver status 2>&1", 3)
      assert_match "traffic_manager is not running", output
    end
  end
end
