class ThriftAT09 < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org"
  url "https://archive.apache.org/dist/thrift/0.9.3/thrift-0.9.3.tar.gz"
  sha256 "b0740a070ac09adde04d43e852ce4c320564a292f26521c46b78e0641564969e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "79422a32dc72ec61bb4f0b9db57a08af6c7478ac676e52f14d05e9060acff2df" => :mojave
    sha256 "c48f3d1200f4cedd092622f380bee268caefa553822c4b0f7bf25aec13d19371" => :high_sierra
    sha256 "d0b173d367891df3d5a9398ea5f5e3a48cbd412fa88955e29d061b7707b7b9e4" => :sierra
  end

  keg_only :versioned_formula

  option "with-java", "Install Java binding"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl"

  if build.with? "java"
    depends_on "ant" => :build
    depends_on :java => "1.8"
  end

  def install
    args = %w[
      --without-erlang
      --without-haskell
      --without-perl
      --without-php
      --without-php_extension
      --without-python
      --without-ruby
      --without-tests
    ]

    args << "--without-java" if build.without? "java"

    ENV.cxx11 if MacOS.version >= :mavericks && ENV.compiler == :clang

    # Don't install extensions to /usr
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
