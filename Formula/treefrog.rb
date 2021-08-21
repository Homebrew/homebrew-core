class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "https://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/v2.1.0.tar.gz"
  sha256 "52ae63955230c73378701fa039da21c2879db5f9d7df20835ecb4c9b09ea95bb"
  license "BSD-3-Clause"
  head "https://github.com/treefrogframework/treefrog-framework.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "1d360984e43004f5b22d5354116c51d151ef1cd84d80f82fb1a09a956145b510"
    sha256 big_sur:       "aaa3208b6c9f7534c1c9e74aecb28f886bd8f8ff32b389cffbb132b95b317f15"
    sha256 catalina:      "967507adb9e26f05f9b7e290b44e7a4ba19e711ce0f995e3fd841a0fcd6e1e1d"
    sha256 mojave:        "d6e058393eb60b8a96d0b4bc7135fba39de517b049aec6e4777e0902b0ed5de2"
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
