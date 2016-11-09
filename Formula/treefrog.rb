class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "http://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/v1.13.0.tar.gz"
  sha256 "850744fef5254a8b2de1d949ba3490514ce1095e9a3e81da40aa8160129e14a1"
  head "https://github.com/treefrogframework/treefrog-framework.git", :branch => "master"

  bottle do
    sha256 "8d5daeb95fabb1bc5d0821cd4a29414b1cbc2d5483b094dd8d8a435172028685" => :sierra
    sha256 "8d5daeb95fabb1bc5d0821cd4a29414b1cbc2d5483b094dd8d8a435172028685" => :el_capitan
  end

  option "with-mysql", "enable --with-mysql option for Qt build"
  option "with-oci", "enable --with-oci option for Qt build"
  option "with-postgresql", "enable --with-postgresql option for Qt build"
  option "with-qt5", "build and link with QtGui module"

  depends_on :macos => :el_capitan
  depends_on :xcode => [:build, "8.0"]

  qt5_build_options = []
  qt5_build_options << "with-oci" if build.with?("oci") && ENV["ORACLE_HOME"]
  qt5_build_options << "with-mysql" if build.with?("mysql")
  qt5_build_options << "with-postgresql" if build.with?("postgresql")
  depends_on "qt5" => qt5_build_options

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-gui-mod" if build.with? "qt5"

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
    assert File.exist?("hello")
    cd "hello" do
      assert File.exist?("hello.pro")
      system HOMEBREW_PREFIX/"opt/qt5/bin/qmake"
      assert File.exist?("Makefile")
      system "make"
      system bin/"treefrog", "-v"
    end
  end
end
