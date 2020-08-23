class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "https://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/v1.29.0.tar.gz"
  sha256 "e5c0dbd6e317d27289bd9f500fae3bd84c74c1e982b914ae193b279c35e1bc0f"
  license "BSD-3-Clause"
  head "https://github.com/treefrogframework/treefrog-framework.git"

  bottle do
    sha256 "b60083bd0a5e7ae3d938d10fd44b22ec00a49efdf984294f02cfd88fd859af52" => :catalina
    sha256 "e87f7b1ff88ed2cff824039ac6acbf1437e9adcc4599cd0dc6162194fc861733" => :mojave
    sha256 "a690eac1c340e7695a25b2f561d86b33cb5d2c970f6b6961799257787af89a65" => :high_sierra
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
