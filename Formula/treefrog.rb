class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "http://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/v1.22.0.tar.gz"
  sha256 "0b9d79d0e17266ff603c1ff812289e8d2500d8f758d3c700ccc3aaad51e3751d"
  head "https://github.com/treefrogframework/treefrog-framework.git"

  bottle do
    sha256 "c556be38f614f516c43ccf411d1c6002349b4931b2e32015e162087231dc5649" => :mojave
    sha256 "246236215fdb5e23dd57a58b53c2c4c41ea802468c614c8a7075c576e24644bc" => :high_sierra
    sha256 "451ff0b20b9ca36b1eb6eaf6af9c13a56e74031d6c15586fa8920f1189d67262" => :sierra
    sha256 "6ea31d04a301bee2b365c5affaea54286814718636386e2e0c9a2bfa9472c1f3" => :el_capitan
  end

  depends_on :xcode => ["8.0", :build]
  depends_on :macos => :el_capitan
  depends_on "qt"

  def install
    system "./configure", "--prefix=#{prefix}"

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
