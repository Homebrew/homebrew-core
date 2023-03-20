class Trafficserver < Formula
  desc "HTTP/1.1 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  url "https://downloads.apache.org/trafficserver/trafficserver-9.2.0.tar.bz2"
  mirror "https://archive.apache.org/dist/trafficserver/trafficserver-9.2.0.tar.bz2"
  sha256 "45cc8198e2b0a12fad41d1cdc7e59675a64e1a38c6845923924de7bcfb5f74e4"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "618c899fe9753c75ba338a0ac3ac39b58367eb78ae83c916ac585dffe76944cb"
    sha256 arm64_monterey: "87288afff7329c6630a092d0e5322367cf3f5cc53e4e4fd17ed440f3ab4ce97a"
    sha256 arm64_big_sur:  "0af95c168e7d5af31d8179f690863d408139c2f0fb983322137d069e35bdacf8"
    sha256 ventura:        "21b8b4aa2f4c96f76e38853c4afde0f3aa294791d6eb17da9c0bb22c1edb840e"
    sha256 monterey:       "898575eb75584f9c884c7580bc00344bf7a49ddb295cdc98e72761c117d6de38"
    sha256 big_sur:        "f8d42c92a06c7b472c10f34a047dc417079539d9cf6c1581cf4ae0f4919222af"
    sha256 x86_64_linux:   "eb16bfdc1c6ec0ff60d434aa86ab639ac02e40110c3fe35dfa8751d46d990974"
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
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

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
