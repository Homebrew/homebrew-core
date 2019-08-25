class Trafficserver < Formula
  desc "HTTP/1.1 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"

  stable do
    url "https://archive.apache.org/dist/trafficserver/trafficserver-7.1.8.tar.bz2"
    sha256 "577bd6856612cebfc7c9ab3153a56a331ea6563cb750eb9fec88ac8896d6b60e"
  end

  bottle do
    sha256 "d897fd2ad8c55e5982ad2a3293180c5baca6d12ff355df8fff88f3f4c26bf730" => :mojave
    sha256 "8798c321ad6b052eab2a8ee3be53c65230a5748b71343012d4116e04cf5cbe3e" => :high_sierra
    sha256 "e4406ff29b744c822d7e6661efdda7e04f08afe8b111a31d07c1bce05daa1732" => :sierra
  end

  head do
    url "https://github.com/apache/trafficserver.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build

    fails_with :clang do
      build 800
      cause "needs C++17"
    end
  end

  depends_on "openssl"
  depends_on "pcre"

  def install
    ENV.cxx11 if build.stable?

    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --localstatedir=#{var}
      --sysconfdir=#{etc}/trafficserver
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework
      --with-group=admin
      --disable-silent-rules
      --enable-experimental-plugins
    ]

    system "autoreconf", "-fvi" if build.head?
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
    output = shell_output("#{bin}/trafficserver status")
    assert_match "Apache Traffic Server is not running", output
  end
end
