class Trafficserver < Formula
  desc "HTTP/1.1 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  url "https://downloads.apache.org/trafficserver/trafficserver-9.2.2.tar.bz2"
  mirror "https://archive.apache.org/dist/trafficserver/trafficserver-9.2.2.tar.bz2"
  sha256 "5960dd2d075e8f1c71d299a09155ca8ed6dd02af1d39678e7379c1e5bd81c388"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 arm64_ventura:  "9deeccd755fa83b9570c876b4fcaff07d116552e7e06af1ce7f6ca3f690412fc"
    sha256 arm64_monterey: "16f589e488c325a0bbcc55e46ef39468526286bbcd38a4277e189cea42f6bceb"
    sha256 arm64_big_sur:  "2f340076bfcb24ab8e723166171a7ce5a9a0aeffa681f1bebd7b6918f9a49795"
    sha256 ventura:        "defc92934de8f85f91674b7974b0e7bf29a91d899d8a004b09f63cc3b8429074"
    sha256 monterey:       "8509309e4f08579095ccbc35fc1d6f5ccb8e7df0abbe63d02791079981939723"
    sha256 big_sur:        "be51035d713408d1fe9d3136c8732350816fb3e7b257900249c3348c9d466609"
    sha256 x86_64_linux:   "fb19527c0a3d968e9ca1f3fdfd190ed5072eedaab0d373d288e56012b7a49137"
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
