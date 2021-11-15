class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "https://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/v2.2.0.tar.gz"
  sha256 "9989b4f2fd5b00b603acdf293d74e0261115bd297d706e6d9af6f3dfdf5c108f"
  license "BSD-3-Clause"
  head "https://github.com/treefrogframework/treefrog-framework.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "f3db6295ee07c312b61271c8f1c770231827e303855ff24e00810deaf9b2aa28"
    sha256 arm64_big_sur:  "5abd291b07c9b01836cca2e0c77f1e6dc3efa26f6f4a9bfe5ae44dbadefaa20a"
    sha256 monterey:       "cba31d2cef437bf03ce1870df5273b98c36c09a0a9dcb6db2312ac9755f6768d"
    sha256 big_sur:        "8f3785e141e607b61fde6a849d6dd7b3f1b6f60040aa8b81e15a0c3c0c5d330c"
    sha256 catalina:       "508314c683b84821d88dc5d2a0a7cf4a6f56ecb3f988e9077215e7586c915078"
  end

  depends_on xcode: :build
  depends_on "mongo-c-driver"
  depends_on "qt"

  def install
    inreplace "src/corelib.pro", "/usr/local", HOMEBREW_PREFIX

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
