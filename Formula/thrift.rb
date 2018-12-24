class Thrift < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=/thrift/0.11.0/thrift-0.11.0.tar.gz"
  sha256 "c4ad38b6cb4a3498310d405a91fef37b9a8e79a50cd0968148ee2524d2fa60c2"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5b99e08e1a69b6b9e39769982efec86fd773753d39439ca89011e180bcdb9249" => :mojave
    sha256 "3a0d80b8f12a25fc87a4fe58722357c932c320a5d9a79f27346d21bcb956a337" => :high_sierra
    sha256 "85bc8f2f5634985803ae738a548710cb6f0ca71acb0a35b7b2f29631b894820d" => :sierra
  end

  head do
    url "https://github.com/apache/thrift.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  option "with-java", "Install Java binding"

  deprecated_option "with-python" => "with-python@2"

  depends_on "bison" => :build
  depends_on "boost"
  depends_on "openssl"
  depends_on "python@2" => :optional

  if build.with? "java"
    depends_on "ant" => :build
    depends_on :java => "1.8"
  end

  def install
    system "./bootstrap.sh" unless build.stable?

    args = %W[
      --disable-debug
      --disable-tests
      --prefix=#{prefix}
      --libdir=#{lib}
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --without-erlang
      --without-haskell
      --without-perl
      --without-php
      --without-php_extension
      --without-ruby
    ]

    args << "--without-python" if build.without? "python@2"
    args << "--without-java" if build.without? "java"

    ENV.cxx11 if MacOS.version >= :mavericks && ENV.compiler == :clang

    # Don't install extensions to /usr:
    ENV["PY_PREFIX"] = prefix
    ENV["PHP_PREFIX"] = prefix
    ENV["JAVA_PREFIX"] = buildpath

    system "./configure", *args
    ENV.deparallelize
    system "make"
    system "make", "install"

    # Even when given a prefix to use it creates /usr/local/lib inside
    # that dir & places the jars there, so we need to work around that.
    (pkgshare/"java").install Dir["usr/local/lib/*.jar"] if build.with? "java"
  end

  def caveats; <<~EOS
    To install Ruby binding:
      gem install thrift
  EOS
  end

  test do
    system "#{bin}/thrift", "--version"
  end
end
