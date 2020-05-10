class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "https://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/v1.29.0.tar.gz"
  sha256 "e5c0dbd6e317d27289bd9f500fae3bd84c74c1e982b914ae193b279c35e1bc0f"
  head "https://github.com/treefrogframework/treefrog-framework.git"

  bottle do
    sha256 "c4451933e3b019ac14f78e283fe7ad348cfd79d4d15a0be97595783904d75867" => :catalina
    sha256 "50687898d869b756ea186f630d084f11b5e5beedee9ca644cb5b73daa6c181cc" => :mojave
    sha256 "6c479fd89e4a832051df86abedb3e67cf4b33ee38a64968d5535873b97c8e08d" => :high_sierra
  end

  depends_on :xcode => ["8.0", :build]
  depends_on :macos => :el_capitan
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
