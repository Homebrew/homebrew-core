class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "https://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/v1.31.1.tar.gz"
  sha256 "282197f1735f7766a804e1f06e29b45754e082db2eb596edcd929f8e308b2887"
  license "BSD-3-Clause"
  head "https://github.com/treefrogframework/treefrog-framework.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 big_sur:  "d865266f65ca621ad8cc3f479ab5a80163b780d9a7507b95c0ce7d9dbda274ff"
    sha256 catalina: "753c0f6725a75a4c61c50c9ba82c69d17a45adefc462c07942d8780e5fdb7080"
    sha256 mojave:   "a3a7ed90190f54b848c92998924243bf376d9a4e13f44a03ef1212d4e83cd163"
  end

  depends_on xcode: :build
  depends_on "mongo-c-driver"
  depends_on "qt@5"

  def install
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
      system Formula["qt@5"].opt_bin/"qmake"
      assert_predicate Pathname.pwd/"Makefile", :exist?
      system "make"
      system bin/"treefrog", "-v"
    end
  end
end
