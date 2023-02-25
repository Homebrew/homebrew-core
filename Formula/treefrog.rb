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
    sha256 arm64_ventura:  "57327c1eab74babf1ea4b1b661ed83c731a0fbf67fa05e3ae81c53b76b7d3632"
    sha256 arm64_monterey: "2cda35d89279eb669ffd0483b561b736180b540166360cd16705600397276dd0"
    sha256 arm64_big_sur:  "2aa8ed9dc3b192b8e68f32519154ad7b40122e6b384cfab4793baa8e39747b65"
    sha256 ventura:        "7904a37a4810adce21c768212623d5fb5bcc0239978f4c6bcf7e5121a7cccb10"
    sha256 monterey:       "404d87c20a1b963bad0f5ff21b34c7bddb1d09b09d5a5d7263b934a24fec5e7d"
    sha256 big_sur:        "0c49ef371594442cd70a8fda81dc14895d83440a29c535fbf396f577b69ed049"
    sha256 x86_64_linux:   "8a6ddbf29eb61446254a3c1c41161c36d0235e8ecfbb746f72ffdf7f08226673"
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
