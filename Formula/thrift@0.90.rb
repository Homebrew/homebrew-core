# The 0.9.0 tag in homebrew repository isn't working in OSX Mavericks
# this version fixes Cpp11 problems about syntax and tr1 headers
# All patches and this file can be found in this public gist:
# https://gist.githubusercontent.com/rafaelverger/58b6eeafaae7d28b06cc
class ThriftAT090 < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org"
  url "https://archive.apache.org/dist/thrift/0.9.0/thrift-0.9.0.tar.gz"
  sha256 "71d129c49a2616069d9e7a93268cdba59518f77b3c41e763e09537cb3f3f0aac"

  bottle do
    cellar :any
    sha256 "826d38fd6b828df82627262cf539e6fc5c96c8b8034b11bfc2f13d87f3115aa8" => :sierra
    sha256 "0c93627496d65905caf00eadd37a7781a5174b29be9408c795bfb5ffb60a81fb" => :el_capitan
    sha256 "fb14b67511c90df0e2b9c379d13d8436f2d81670707938eb2cb83b7276663d11" => :yosemite
  end

  keg_only :versioned_formula

  # These patches are 0.9.0-specific and can go away once a newer version is release
  [
    # patch-tsocket.patch
    %w[a1dc9e54ffacf04c6ba6d1e37b734684ff09d149a88ca7425a4237267f674829 tsocket.patch],
    # patch-cxx11-compat.patch
    %w[74fd5282f159bf4d7ee5ca977b36534e2182709fe4c17cc5907c6bd615cfe0ef cxx11-compat.patch],
    # patch-use-boost-cpp-client-server.patch
    %w[2ea5a69c5358a56ef945d4fb127c11a7797afc751743b20f58dfff0955a68117 use-boost-cpp-client-server.patch],
    # patch-remove-tr1-dependency.patch
    %w[c4419ce40b7fda9ffd58a5dad7856b64ee84e3c1b820f3a64fed0b01b4bc9c42 remove-tr1-dependency.patch],
  ].each do |sha, patch|
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/dee880b1baba827255f7b0806ca32d36c4d1c2ca/thrift/0.9.0/#{patch}"
      sha256 sha
    end
  end

  option "with-haskell", "Install Haskell binding"
  option "with-erlang", "Install Erlang binding"
  option "with-java", "Install Java binding"
  option "with-perl", "Install Perl binding"
  option "with-php", "Install Php binding"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl"
  depends_on :python => :optional

  def install
    args = ["--without-ruby", "--without-tests", "--without-php_extension"]

    args << "--without-python" if build.without? "python"
    args << "--without-haskell" if build.without? "haskell"
    args << "--without-java" if build.without? "java"
    args << "--without-perl" if build.without? "perl"
    args << "--without-php" if build.without? "php"
    args << "--without-erlang" if build.without? "erlang"

    ENV.cxx11 if MacOS.version >= :mavericks && ENV.compiler == :clang

    # Don't install extensions to /usr:
    ENV["PY_PREFIX"] = prefix
    ENV["PHP_PREFIX"] = prefix

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}",
                          *args
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_match /Thrift/, shell_output("#{bin}/thrift --version", 1)
  end
end
