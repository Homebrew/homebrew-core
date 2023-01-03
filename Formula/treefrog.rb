class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "https://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/v2.6.0.tar.gz"
  sha256 "edddf0a59713767d7dff12064b502576492827f8eef72dc1ddb82eabd4be7349"
  license "BSD-3-Clause"
  head "https://github.com/treefrogframework/treefrog-framework.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "4e16576c624b6c2329823cdca1f849ec002249d9be4c2d25d2efdb3e36200264"
    sha256 arm64_monterey: "ee24340f99979f8f1ed158a7adc41d764df600cbaab093009e646189f35f8b82"
    sha256 arm64_big_sur:  "298b39bb3671a9bd6e895bcd542fcb797a70626416f7f4138aa55718a23f5a8e"
    sha256 ventura:        "c99b7514da2f7b8a2189d3d8bd44f9cfcc48ec35b52e287495f047acbfb76b99"
    sha256 monterey:       "ab0ca5b1d83ea07f70ff2abe0d3822da9db92ac4683c9fb51c401ac4fe8b2b23"
    sha256 big_sur:        "c6110d26d893fff436def3015e4be54c798ee424aefd11d1f35a182fb3b6abee"
    sha256 x86_64_linux:   "be8d40a0bb91e8b2b1f6debe34bf14e37058a3e7a4c2ba0cfebee2ccf3ddc8c8"
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
      inreplace "src/corelib.pro", "/usr/include", HOMEBREW_PREFIX/"include"
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
      # FIXME: `qmake` has a broken mkspecs file on Linux.
      # Remove when the following PR is merged:
      # https://github.com/Homebrew/homebrew-core/pull/107400
      return if OS.linux?

      system Formula["qt"].opt_bin/"qmake"
      assert_predicate Pathname.pwd/"Makefile", :exist?
      system "make"
      system bin/"treefrog", "-v"
    end
  end
end
