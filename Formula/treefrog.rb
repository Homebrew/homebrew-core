class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "http://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/v1.19.0.tar.gz"
  sha256 "7e1017c00dba4aa111882aa7ac334956a3b8b64466bf1137379b2b326caf4047"
  head "https://github.com/treefrogframework/treefrog-framework.git"

  bottle do
    sha256 "ec2359159e02bf595d0cbf91a23e3975b9cd59e5655fe8d157b95ffb8e8d62a2" => :high_sierra
    sha256 "a808d24e338c2e8c0b80e34ca00aa539b8b0a26912c493cdfabf7f4c33d1a619" => :sierra
    sha256 "7b015baad146c53ab210c931c99710b41b5a9c62b2c09a0d5eb7a4ed832f6427" => :el_capitan
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
      assert_predicate testpath/"hello.pro", :exist?
      system HOMEBREW_PREFIX/"opt/qt/bin/qmake"
      assert_predicate testpath/"Makefile", :exist?
      system "make"
      system bin/"treefrog", "-v"
    end
  end
end
