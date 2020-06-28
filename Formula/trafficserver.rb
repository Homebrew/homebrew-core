class Trafficserver < Formula
  desc "HTTP/1.1 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=trafficserver/trafficserver-8.0.8.tar.bz2"
  mirror "https://archive.apache.org/dist/trafficserver/trafficserver-8.0.8.tar.bz2"
  sha256 "dfe88d21897ea667d14e0813df47af78c19d5d299a5f5ab029a02e63f724ceb0"

  bottle do
    sha256 "67dccebd2905aa65f947e31b20a206e93ff73ffb2e55da5e200fc1537c23cf53" => :catalina
    sha256 "865680570510222fc4219ccc2cac3fa5b5121ceafd87b5903c8659288b4e1358" => :mojave
    sha256 "296bc5028f9b083414d899ebab0dfb2e7a98b3fa88c2bc156d5ee8c8006cc387" => :high_sierra
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

  depends_on "openssl@1.1"
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
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
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
