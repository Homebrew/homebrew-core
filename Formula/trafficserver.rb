class Trafficserver < Formula
  desc "HTTP/1.1 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  license "Apache-2.0"
  revision 1

  stable do
    url "https://downloads.apache.org/trafficserver/trafficserver-9.1.1.tar.bz2"
    mirror "https://archive.apache.org/dist/trafficserver/trafficserver-9.1.1.tar.bz2"
    sha256 "90cfa975858d50bc1995bee195f13ff45497773c2f90363332516fd3fdafd7e8"

    # Fix macOS ARM build error due to undefined symbols
    # TODO: remove in the next release
    patch do
      url "https://github.com/apache/trafficserver/commit/393e223ab0217645a18c112fe94afee029c90c63.patch?full_index=1"
      sha256 "f412de78a8fa9cc8d79ebc9994d4530d15cf3993d7d363bdfae64c02114355c5"
    end
  end

  bottle do
    sha256 catalina: "c28ab8ba05de3d98d81bcdbfa89c771d458a3326023909a76d2893a6fd20e89c"
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
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "yaml-cpp"

  on_macos do
    # Need to regenerate configure to fix macOS 11+ build error due to undefined symbols
    # See https://github.com/apache/trafficserver/pull/8556#issuecomment-995319215
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  on_linux do
    depends_on "gcc"
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
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
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
