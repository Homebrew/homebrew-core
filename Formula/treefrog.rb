class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "http://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/v1.20.0.tar.gz"
  sha256 "72d22e3051cea9c42ad163c9f2a706d0b47640648c594ec7c4beebb0899ee57b"
  head "https://github.com/treefrogframework/treefrog-framework.git"

  bottle do
    sha256 "f1a48752ac8103cc489909e828e33acc71757b27dd15ec507caff708037f96c4" => :high_sierra
    sha256 "6c8b7fa1940f50371cae7e0f2851423babf889a2644b775d39e94b9c10108bac" => :sierra
    sha256 "cb407f8bc9eaf7b6bbb1a28e8305f32819216bb2bf4c4836ed942b0d33a6d0e3" => :el_capitan
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
