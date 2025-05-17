class QtWebview < Formula
  desc "Light-weight web view"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.0/submodules/qtwebview-everywhere-src-6.9.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.0/submodules/qtwebview-everywhere-src-6.9.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.0/submodules/qtwebview-everywhere-src-6.9.0.tar.xz"
  sha256 "5b24070e8ceb12c3c4df5a887f3ffc3544193646386e6ce18e41c20d42d7ed6b"
  license all_of: [
    "BSD-3-Clause",
    "GFDL-1.3-no-invariants-only",
    "GPL-2.0-only",
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } },
    "LGPL-3.0-only",
  ]
  head "https://code.qt.io/qt/qtwebview.git", branch: "dev"

  livecheck do
    formula "qt"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  depends_on "qt"
  depends_on "qt-webengine"

  def install
    plugin_rpath = rpath(source: share/"qt/plugins/webview", target: Formula["qt-webengine"].opt_lib)

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    "-DCMAKE_INSTALL_RPATH=#{plugin_rpath}",
                    "-DCMAKE_STAGING_PREFIX=#{prefix}",
                    *std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    lib.glob("*.framework") do |f|
      # Some config scripts will only find Qt in a "Frameworks" folder
      frameworks.install_symlink f
      # Some dependents' test use include path (e.g. `gecode` and `qwt`)
      include.install_symlink f/"Headers" => f.stem
    end
  end

  test do
    # https://github.com/qt/qtwebview/tree/dev/tests/manual/inquickwidget
    (testpath/"test.pro").write <<~QMAKE
      QT        += core gui webview quickwidgets
      CONFIG    -= app_bundle
      SOURCES   += main.cpp
      RESOURCES += qml.qrc
      DISTFILES += main.qml
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #include <QTimer>
      #include <QtWidgets/qapplication.h>
      #include <QtWidgets/QHBoxLayout>
      #include <QtQuickWidgets/qquickwidget.h>

      int main(int argc, char *argv[])
      {
        QQuickWindow::setGraphicsApi(QSGRendererInterface::GraphicsApi::OpenGL);
        QApplication a(argc, argv);
        QWidget w;
        w.setGeometry(0, 0, 800, 600);
        w.setLayout(new QHBoxLayout);
        QQuickWidget *qw = new QQuickWidget;
        qw->setResizeMode(QQuickWidget::ResizeMode::SizeRootObjectToView);
        qw->setSource(QUrl(QStringLiteral("qrc:/main.qml")));
        w.layout()->addWidget(qw);
        w.show();
        QTimer::singleShot(2000, &a, SLOT(quit()));
        return a.exec();
      }
    CPP

    (testpath/"main.qml").write <<~QML
      import QtQuick 2.0
      import QtWebView 1.1

      Rectangle {
        anchors.fill: parent
        color: "green"

        WebView {
          anchors.fill: parent
          url: "https://qt.io"
        }
      }
    QML

    (testpath/"qml.qrc").write <<~XML
      <RCC>
        <qresource prefix="/">
          <file>main.qml</file>
        </qresource>
      </RCC>
    XML

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    ENV["QTWEBENGINE_DISABLE_SANDBOX"] = "1"
    ENV.delete "CPATH" if OS.mac?

    system Formula["qt"].bin/"qmake", testpath/"test.pro"
    system "make"
    system "./test"
  end
end
