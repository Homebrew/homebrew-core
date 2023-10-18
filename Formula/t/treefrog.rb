class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "https://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/v2.7.1.tar.gz"
  sha256 "c7d2cb55a8796d7d0710af62068471dfb606fc5fdcdbaf7c91ec4b2c31a63a26"
  license "BSD-3-Clause"
  head "https://github.com/treefrogframework/treefrog-framework.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "40a0e96c8c25fe038d5227ec2e45788a371439201cbe8c33c17f1d3e4822155a"
    sha256 arm64_ventura:  "24ff7d1885a2facb2ebab3e44e57a46204e9da4f3081a68a7c06d3c56a11d458"
    sha256 arm64_monterey: "8689db039ecb5c5e995633167686066bf5b8c647eb2c5aa09aca37f2f6a5f816"
    sha256 arm64_big_sur:  "8e22e6d22821a946a7dee1998e9c2454ab2d1328c9fd4034573cf686d87cc18c"
    sha256 sonoma:         "e6f45d86d559bde8f06e4c5f8c625b6e09c4fa87a44bc64593035fcea0310145"
    sha256 ventura:        "61374c291147748e5d05cd4d260e2943eb5062343233958de37548e74dd2ba7a"
    sha256 monterey:       "e4dc9e48620c52d7c897c5ea2d0a8895e75d7c3aa7e91a6f42fd9ef4eb307ae6"
    sha256 big_sur:        "61761bf0d4017491a07436d5270a8a97427ac378a52ca4cd1c6ec6304042332b"
    sha256 x86_64_linux:   "f5c91db15d91d8f992c7c59f6c890e50d6664e6ae87ce4390e862b266248ddd6"
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
