class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "https://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/v2.7.0.tar.gz"
  sha256 "fee114160986a656ee39edcd97a4ee7d346f596fb682c8c9bdfae1df59d4a9e9"
  license "BSD-3-Clause"
  head "https://github.com/treefrogframework/treefrog-framework.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "9ba098cef4a0a1ee9e901c6ab44a479343b05c38cc98c7ae5b7d5d8aedcd0db9"
    sha256 arm64_monterey: "8e5d64fd8623d052ea4b0b1c317a38c19bcac70e3e6eb50a57127e0ab9ae4afd"
    sha256 arm64_big_sur:  "69eab49c877b06af9e356373ce8b3025c1784f3a84c5f683a809e02016876ed1"
    sha256 ventura:        "9123956bfecd0df7ade211892c4758b9e8d6ac5f8abd10371a3479e000cc3f40"
    sha256 monterey:       "a68d5e4caef66e2c55a4fb5896c3d11d9203fc8bc663905ff65139de12cf01fd"
    sha256 big_sur:        "b2e570d00817bc9cc46b85092835411e1d6b4423d22455082ef062648aae09a1"
    sha256 x86_64_linux:   "2c39ccce700b3156a6da3dbe18062234c0fae2601fd0ae0ec4b9c2b70aebe6b1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build
  depends_on "gflags"
  depends_on "glog"
  depends_on "mongo-c-driver"
  depends_on "qt"

  fails_with gcc: "5"

  def install
    # src/corelib.pro hardcodes different paths for mongo-c-driver headers on macOS and Linux.
    if OS.mac?
      inreplace "src/corelib.pro", "/usr/local", HOMEBREW_PREFIX
    else
      inreplace "src/corelib.pro", "/usr/lib", HOMEBREW_PREFIX/"lib"
    end

    system "./configure", "--prefix=#{prefix}", "--enable-shared-mongoc", "--enable-shared-glog"

    cd "src" do
      system "make"
      system "make", "install"
    end

    cd "tools" do
      system "make"
      system "make", "install"
    end
  end

  test do
    ENV.delete "CPATH"
    system bin/"tspawn", "new", "hello"
    assert_predicate testpath/"hello", :exist?
    cd "hello" do
      assert_predicate Pathname.pwd/"hello.pro", :exist?

      system Formula["qt"].opt_bin/"qmake"
      assert_predicate Pathname.pwd/"Makefile", :exist?
      system "make"
      system bin/"treefrog", "-v"
    end
  end
end
