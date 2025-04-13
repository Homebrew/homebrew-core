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

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:  "136f2812341e94fb98be285e00f938c7078aa855dd766be89e8b27b65ff61729"
    sha256 cellar: :any,                 arm64_ventura: "be7a809955ab72f32520add889794883d4da77781387ba7110bf8ab75b03ce8d"
    sha256 cellar: :any,                 sonoma:        "bf1e1368404ef259bdf0a446a2c5765ed38851d8fe8c050f5a6138a757f4044e"
    sha256 cellar: :any,                 ventura:       "73c072ac764154eac4940a150ade2716b2b5240f0aec31438b808d1c80abc404"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13db11bcb1836554ed9d2d1be1e2a09c645f4278eeb282c1386554865915adc0"
  end

  depends_on "qt"

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

    system Formula["qt"].bin/"qmake", "test.pro"
    system "make"
    system "./test"
  end
end
