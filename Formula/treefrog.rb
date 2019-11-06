class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "http://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/v1.24.0.tar.gz"
  sha256 "4060736e96bb3c84fe3d0a251cf140baf29724d4cb50212cee4dbf1d491982ed"
  head "https://github.com/treefrogframework/treefrog-framework.git"

  bottle do
    sha256 "d0c424e40d84fcef8d35bb792f8d3adaf6ebdee2118213c8b13b0e3c57cdea7c" => :catalina
    sha256 "bbf06535ab64a86ae25ddaf3e2ac066ec48143aa44dc358cd63651c60d9d5cb3" => :mojave
    sha256 "22653f1d3be2a7dfae678d4d8d9be1b14be167ffc1f3d1cc040e9c3cf1368475" => :high_sierra
    sha256 "19cc929312e7be589ec943cc4d12a1a34bd4f0b37a008202ff4e551df5c076b1" => :sierra
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
