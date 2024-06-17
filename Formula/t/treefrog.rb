class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "https://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "90cc96a883c09e42a73b6ca7a8ed262ba59c398966c32e984dd3f9d49feda2c2"
  license "BSD-3-Clause"
  head "https://github.com/treefrogframework/treefrog-framework.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "6c780fca27734da1076f7483d8bb87b35799d25dce52b706e69d65fe5dcc7259"
    sha256 arm64_ventura:  "f1eb50428c185ec2052a5c4bbdbe68818a020c9ba68505dbc19b58851f10e11e"
    sha256 arm64_monterey: "063a507434d9c87b19a59d5d1bd0c73e82a73a268353cf9e989e0289fabdb6d4"
    sha256 sonoma:         "942d2b7aec40f2630b90758724854dc45a6e58ced2e9085c6f0a4dd49fbff0dd"
    sha256 ventura:        "e405fe58976f308f25e5d7924bff0f77589a592f4e1ff0f2db7bbed4efdba767"
    sha256 monterey:       "27c89d9321cba0ef0301efe2ff663ffe5ddb79e198dc8f975975356c125bd2f8"
    sha256 x86_64_linux:   "cb7320c8416c2d800ee3c744e9e48e22a957e0af6c03ffe31a2fed205f79dd6e"
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
