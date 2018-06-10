class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "http://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/v1.22.0.tar.gz"
  sha256 "0b9d79d0e17266ff603c1ff812289e8d2500d8f758d3c700ccc3aaad51e3751d"
  head "https://github.com/treefrogframework/treefrog-framework.git"

  bottle do
    sha256 "6c1398ebc178176888a02a3ce244455e88c17433c3d9dc1eb0067e7772bb2fc4" => :high_sierra
    sha256 "397a1b29e4360479db8ea6ba139e10f1df54eb60064b16e8b3230764b2ee6cc1" => :sierra
    sha256 "124b9f9e2fbde088ee8d4462efb38142bde569603ff1b1b656d9f601a1f941b0" => :el_capitan
  end

  deprecated_option "with-qt5" => "with-qt"

  option "with-mysql", "enable --with-mysql option for Qt build"
  option "with-postgresql", "enable --with-postgresql option for Qt build"
  option "with-qt", "build and link with QtGui module"

  depends_on :macos => :el_capitan
  depends_on :xcode => [:build, "8.0"]

  qt_build_options = []
  qt_build_options << "with-mysql" if build.with?("mysql")
  qt_build_options << "with-postgresql" if build.with?("postgresql")
  depends_on "qt" => qt_build_options

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-gui-mod" if build.with? "qt"

    system "./configure", *args

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
