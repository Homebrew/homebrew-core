class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "http://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/v1.23.0.tar.gz"
  sha256 "d1fad78445bc352a9b95a77b961407fbe0fab4c19da9a54ed50088b9b3a0c616"
  head "https://github.com/treefrogframework/treefrog-framework.git"

  bottle do
    sha256 "bc4b2cde6f08f0c88352cfa798efbdbf8f7ed17c974f59cce4c6a99472723f61" => :mojave
    sha256 "bc4b2cde6f08f0c88352cfa798efbdbf8f7ed17c974f59cce4c6a99472723f61" => :high_sierra
    sha256 "9f32c83a28d3c73dbc3424dfab5d5643174adca1838752cca607f27a85c4f72e" => :sierra
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
