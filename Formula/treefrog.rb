class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "https://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/v2.3.1.tar.gz"
  sha256 "1877efe236d8407ce401c6e21670a0b0714a6dd07f786714c8ea885d8c6393de"
  license "BSD-3-Clause"
  head "https://github.com/treefrogframework/treefrog-framework.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "80a7272e904c060938ddaa19c090822240446e1cf66c2dad5d6ee68b1f451048"
    sha256 arm64_big_sur:  "c9afe4515ec107bf744805b7525faaee6a166f7c12b31d36dc8cd9f13d0b11cc"
    sha256 monterey:       "0f4080bde815c4a090e93e7945991f7e2edb36818243626cc65d45418402a826"
    sha256 big_sur:        "370e03b7c0de69daea6f7d3204d0d3bd07fdc4381134ea46e2991b678cdcedde"
    sha256 catalina:       "b558f6d8c06e8c592ee2a57a8bfa1fdb918b5bc3dc344276b81fb132ac4eec20"
    sha256 x86_64_linux:   "02f14ab3da6f135ed0a214c8b8ddb0bb1ca49b7a8dd55c86f4abdcca9c2be6d3"
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
