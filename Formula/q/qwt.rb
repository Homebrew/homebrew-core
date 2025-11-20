class Qwt < Formula
  desc "Qt Widgets for Technical Applications"
  homepage "https://qwt.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qwt/qwt/6.3.0/qwt-6.3.0.tar.bz2"
  sha256 "dcb085896c28aaec5518cbc08c0ee2b4e60ada7ac929d82639f6189851a6129a"
  license "LGPL-2.1-only" => { with: "Qwt-exception-1.0" }

  livecheck do
    url :stable
    regex(%r{url=.*?/qwt[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "b9997bee5756f9c2f27627b70b4af65e8e83cf742a69fbf190bb82b745ade6f2"
    sha256 cellar: :any,                 arm64_sequoia: "ad7400e7b47e1141ab0dc73e38ba9277e64815563ab09d098d291c279280c042"
    sha256 cellar: :any,                 arm64_sonoma:  "7119f5e278adbd4ea156188b77c2f9a4cb50cce88d78407986c37e431c0a4195"
    sha256 cellar: :any,                 sonoma:        "bfece3bd182b3bacc33ad714238fccbe59427aa405a4f0fe92bc3b7d9c8ac631"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48d6ffede0996476e329902394fe8848a346f057b9a1f7113686b163a4c917c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f2c7c9b88d0214e3fdc7b8fcf9f412fd5f306eacc069adbc388683d1f0f9603"
  end

  depends_on "qttools" => :build
  depends_on "qtbase"
  depends_on "qtsvg"

  on_macos do
    depends_on "qttools"
  end

  # Apply Fedora patch to fix pkgconfig file.
  # Issue ref: https://sourceforge.net/p/qwt/bugs/353/
  patch do
    url "https://src.fedoraproject.org/rpms/qwt/raw/ea40e765e46413ae865a00f606688ea05e378e8a/f/qwt-pkgconfig.patch"
    sha256 "7ceb1153ba1d8da4dd61f343023fe742a304fba9f7ff8737c0e62f7dcb0e2bc2"
  end

  def install
    inreplace "qwtconfig.pri" do |s|
      s.gsub!(/^(\s*QWT_INSTALL_PREFIX\s*=).*$/, "\\1 #{prefix}")
      s.gsub! "= $${QWT_INSTALL_PREFIX}/doc", "= #{doc}"
      s.gsub! "= $${QWT_INSTALL_PREFIX}/plugins/designer", "= $${QWT_INSTALL_PREFIX}/share/qt/plugins/designer"
      s.gsub! "= $${QWT_INSTALL_PREFIX}/features", "= $${QWT_INSTALL_PREFIX}/share/qt/mkspecs/features"
    end

    os = OS.mac? ? "macx" : OS.kernel_name.downcase
    compiler = ENV.compiler.to_s.match?("clang") ? "clang" : "g++"

    system "qmake", "-config", "release", "-spec", "#{os}-#{compiler}"
    system "make"
    system "make", "install"

    # Backwards compatibility symlinks. Remove in a future release
    odie "Remove backwards compatibility symlinks!" if version >= 7
    prefix.install_symlink share/"qt/mkspecs/features"
    (lib/"qt/plugins/designer").install_symlink share.glob("qt/plugins/designer/*")
  end

  test do
    (testpath/"test.pro").write <<~QMAKE
      CONFIG  += console qwt
      CONFIG  -= app_bundle
      SOURCES += test.cpp
      TARGET   = test
      TEMPLATE = app
    QMAKE

    (testpath/"test.cpp").write <<~CPP
      #include <qwt_plot_curve.h>
      int main() {
        QwtPlotCurve *curve1 = new QwtPlotCurve("Curve 1");
        return (curve1 == NULL);
      }
    CPP

    ENV.delete "CPATH"
    ENV["LC_ALL"] = "en_US.UTF-8"

    system Formula["qtbase"].bin/"qmake", "test.pro"
    system "make"
    system "./test"
  end
end
