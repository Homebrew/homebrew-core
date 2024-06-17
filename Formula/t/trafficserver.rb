class Trafficserver < Formula
  desc "HTTP/1.1 and HTTP/2 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  url "https://downloads.apache.org/trafficserver/trafficserver-9.2.4.tar.bz2"
  mirror "https://archive.apache.org/dist/trafficserver/trafficserver-9.2.4.tar.bz2"
  sha256 "fd4601677817de55d841376bb2deecf731f1adf317387148cf9a02f11375b7e4"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sonoma:   "889b463f5351a258143c9dd91e8638905b3c692caeebaad87353e96fca4eb561"
    sha256 arm64_ventura:  "0849e5f0de249825fc0ade51ada327e0bdadf14494f972431a13359c67f35b43"
    sha256 arm64_monterey: "02c34df568a4ab98fb5cdcd103172c8273741f787d52bb4e55395a4b855d46df"
    sha256 sonoma:         "df7d9a477b4a542f5bb657888d3ed5081d7e9136071009f4b9c836069b02f865"
    sha256 ventura:        "75474b792cdf48c366b45788a931e27ec4c5a45be217016f8cecc5d02a765e61"
    sha256 monterey:       "f8b4f04cb576903c4d02aee151f3c2e4406e5f6cba1eec53679f830d54039ad6"
    sha256 x86_64_linux:   "073f02365070dc2dc419c955f833dc19db468e1947a8a143511758cdc9ccab73"
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
  depends_on "pcre" # PCRE2 issue: https://github.com/apache/trafficserver/issues/8780
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
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac?

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
