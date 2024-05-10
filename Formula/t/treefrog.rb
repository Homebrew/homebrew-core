class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "https://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "6b47b6c0d522118b5b765c596dff14c9ea09141da3a1992e7dae44717d579c8d"
  license "BSD-3-Clause"
  head "https://github.com/treefrogframework/treefrog-framework.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "8d74c3b3c574825db5507194470b49e10576cd09dfc81fce059f7137c6d7b7fa"
    sha256 arm64_ventura:  "35f0d759c93b7c666428ab2748cea06e63b8cf81d2b5e3938494dd5a0aea2dba"
    sha256 arm64_monterey: "f0a4bd60e23c9dec41d52e13201dba5bef0099a6a1db80af731985450f9aec0c"
    sha256 sonoma:         "ee5f637c550b2fe5e62b92290c09a59919b148970711022fa50c39eb43097ddb"
    sha256 ventura:        "30dc4592c46bf9fc0fd2b6adc6e7294be173d9e4f0c6ff5957a6d2dd0ffaea0e"
    sha256 monterey:       "9c6f5813b236e1a22c9c4191defd4096cb4da8cd12f5d56e8c4459900ba1308a"
    sha256 x86_64_linux:   "77f22a1dff3eb4e8a8a7c258ff64450a772f4df4ebfb9976dfb9221cf604aff9"
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
