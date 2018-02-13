class ThriftAT09 < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org"
  url "https://archive.apache.org/dist/thrift/0.9.3/thrift-0.9.3.tar.gz"
  sha256 "b0740a070ac09adde04d43e852ce4c320564a292f26521c46b78e0641564969e"

  bottle do
    cellar :any
    sha256 "9bf6dbb1699dd2e47ec08c0a6c45d922bfe44e39541cfa824c6d3fa0e612cbee" => :high_sierra
    sha256 "52d2ce63e41f13d81c4df4cff528d5bd25b75b09316a59e0cd7060bbb313a831" => :sierra
    sha256 "167da043b6111631373371b51e2b6678d84602179d034827dd221e88f6211027" => :el_capitan
  end

  keg_only :versioned_formula

  option "with-haskell", "Install Haskell binding"
  option "with-erlang", "Install Erlang binding"
  option "with-java", "Install Java binding"
  option "with-perl", "Install Perl binding"
  option "with-php", "Install Php binding"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl"
  depends_on "python" => :optional

  if build.with? "java"
    depends_on "ant" => :build
    depends_on :java => "1.8"
  end

  def install
    args = ["--without-ruby", "--without-tests", "--without-php_extension"]

    args << "--without-python" if build.without? "python"
    args << "--without-haskell" if build.without? "haskell"
    args << "--without-java" if build.without? "java"
    args << "--without-perl" if build.without? "perl"
    args << "--without-php" if build.without? "php"
    args << "--without-erlang" if build.without? "erlang"

    ENV.cxx11 if MacOS.version >= :mavericks && ENV.compiler == :clang

    # Don't install extensions to /usr
    ENV["PY_PREFIX"] = prefix
    ENV["PHP_PREFIX"] = prefix
    ENV["JAVA_PREFIX"] = pkgshare/"java"

    # configure's version check breaks on ant >1.10 so just override it. This
    # doesn't need guarding because of the --without-java flag used above.
    inreplace "configure", 'ANT=""', "ANT=\"#{Formula["ant"].opt_bin}/ant\""

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}",
                          *args
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_match "Thrift", shell_output("#{bin}/thrift --version")
  end
end
