class Trafficserver < Formula
  desc "HTTP/1.1 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  url "https://downloads.apache.org/trafficserver/trafficserver-9.1.4.tar.bz2"
  mirror "https://archive.apache.org/dist/trafficserver/trafficserver-9.1.4.tar.bz2"
  sha256 "186cc796d9d783c7c9313d855785b04b8573234b237802b759939c002a64b1df"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "2a218cb530837ee85c8848bf9528dcd24d2b12a76fb4a279ce11b5182c55c542"
    sha256 arm64_monterey: "237dd8cf79dc9b1cb579806c8628b11a3288fa6314580977e773ea9af27f773a"
    sha256 arm64_big_sur:  "d865eac70aeefb577fccade81c2e2acd8855f6aa8a1ca85bdaa45dfa4a2a31a3"
    sha256 ventura:        "0fe7710eca8e8190713a06f73ffd0d854e209e26614ec92ec677c96c5c2643a3"
    sha256 monterey:       "8ae71a89c9751b540dff46ab847aaa6607366d1bd2c2ac6ab8bca802933cf1e0"
    sha256 big_sur:        "d61152e41660a97e00423e42a654869ab63f90bf89b20deded85378ac87789e3"
    sha256 x86_64_linux:   "5f44336902e39bd4debf3ceff1eeb30e236ccb390656138feae53b4af35bfd77"
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
