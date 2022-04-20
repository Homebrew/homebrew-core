class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "https://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/v2.3.0.tar.gz"
  sha256 "e73f2c29d01fb4a41eefd4fc1394c8bf5aaa7d1646fcea88701c6de5621c8d05"
  license "BSD-3-Clause"
  head "https://github.com/treefrogframework/treefrog-framework.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "a92b827a37e292f71a06dc045d90e19647d52ed5d77d9b5c31fa2372fb9f1bfc"
    sha256 arm64_big_sur:  "cbbcd04225065a3f1288571351111257b3b79dbcffbbced68e29ab34edd2f343"
    sha256 monterey:       "d44a6b742510daf871c21243775b1cc078212c27790b91432c18920a1387a96c"
    sha256 big_sur:        "9fb5a0281360d87fd404e254922346df8deeed84f225bd1a87a0e1dac8e46874"
    sha256 catalina:       "e80924533751ba46a8a5fd23d685fd44f236ae4a1049abbedc3db5ea54e9a7c6"
  end

  depends_on xcode: :build
  depends_on "mongo-c-driver"
  depends_on "qt"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    # src/corelib.pro hardcodes different paths for mongo-c-driver headers on macOS and Linux.
    if OS.mac?
      inreplace "src/corelib.pro", "/usr/local", HOMEBREW_PREFIX
    else
      inreplace "src/corelib.pro", "/usr/include", HOMEBREW_PREFIX/"include"
    end

    system "./configure", "--prefix=#{prefix}", "--enable-shared-mongoc"

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
