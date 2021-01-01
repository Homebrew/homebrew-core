class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "https://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/v1.30.0.tar.gz"
  sha256 "e91384f5ed6c14e0a0eccec5467425d598d58dfa4909cf7619bda0f85e6c6aee"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/treefrogframework/treefrog-framework.git"

  bottle do
    sha256 "8af96d330e176d4cc0cc842ac4773ffb65259ab3e5bdab4d9c7130a185978c52" => :big_sur
    sha256 "034a80dd1abd63f9afcb7ddd5753ed69f70806ad2f63d0511c8dbde706f8f3ee" => :catalina
    sha256 "53c4e5ced4f597347ca95fb3b2c6359ce964f3f094ee3032e2d2da6f7016e090" => :mojave
    sha256 "0c31aaf7a5199f8b409288fc3e5fd5d4e154b23e8be83354e1ed8e0fd4bb13ec" => :high_sierra
  end

  depends_on xcode: ["8.0", :build]
  depends_on macos: :el_capitan
  depends_on "mongo-c-driver"
  depends_on "qt"

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
    system bin/"tspawn", "new", "hello"
    assert_predicate testpath/"hello", :exist?
    cd "hello" do
      assert_predicate Pathname.pwd/"hello.pro", :exist?
      system HOMEBREW_PREFIX/"opt/qt/bin/qmake"
      assert_predicate Pathname.pwd/"Makefile", :exist?
      system "make"
      system bin/"treefrog", "-v"
    end
  end
end
