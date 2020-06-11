# Patches for Qt must be at the very least submitted to Qt's Gerrit codereview
# rather than their bug-report Jira. The latter is rarely reviewed by Qt.
class Qt < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/5.15/5.15.0/single/qt-everywhere-src-5.15.0.tar.xz"
  mirror "https://mirrors.dotsrc.org/qtproject/archive/qt/5.15/5.15.0/single/qt-everywhere-src-5.15.0.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/qt/archive/qt/5.15/5.15.0/single/qt-everywhere-src-5.15.0.tar.xz"
  sha256 "22b63d7a7a45183865cc4141124f12b673e7a17b1fe2b91e433f6547c5d548c3"

  head "https://code.qt.io/qt/qt5.git", :branch => "dev", :shallow => false

  bottle do
    cellar :any
    sha256 "c1094fb3e2c5efa2580f4ad36f240a83b08a5118aa8f12a526f08fca27e6d6c7" => :catalina
    sha256 "86674d9e61e1f75a20029974a01804a9fa0e6ea2fdc8fe10cb964ab8aea2a4e4" => :mojave
    sha256 "c579327b288cfe0f23d6bd41e6e3b672538b6f19fbc0379322ce5c0ba422e794" => :high_sierra
  end

  keg_only "Qt 5 has CMake issues when linked"

  depends_on "pkg-config" => :build
  depends_on :xcode => :build
  depends_on :macos => :sierra

  uses_from_macos "bison"
  uses_from_macos "flex"
  uses_from_macos "sqlite"

  # Fix build on 10.15.0 SDK, included in 10.15.1
  # https://github.com/qt/qtbase/commit/a9f82b8b2c19ecc5bf5ab0d376780c34e8435202
  patch :DATA

  def install
    args = %W[
      -verbose
      -prefix #{prefix}
      -release
      -opensource -confirm-license
      -system-zlib
      -qt-libpng
      -qt-libjpeg
      -qt-freetype
      -qt-pcre
      -nomake examples
      -nomake tests
      -no-rpath
      -pkg-config
      -dbus-runtime
      -proprietary-codecs
    ]

    system "./configure", *args

    # Remove reference to shims directory
    inreplace "qtbase/mkspecs/qmodule.pri",
              /^PKG_CONFIG_EXECUTABLE = .*$/,
              "PKG_CONFIG_EXECUTABLE = #{Formula["pkg-config"].opt_bin/"pkg-config"}"
    system "make"
    ENV.deparallelize
    system "make", "install"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink Dir["#{lib}/*.framework"]

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    Pathname.glob("#{lib}/*.framework/Headers") do |path|
      include.install_symlink path => path.parent.basename(".framework")
    end

    # Move `*.app` bundles into `libexec` to expose them to `brew linkapps` and
    # because we don't like having them in `bin`.
    # (Note: This move breaks invocation of Assistant via the Help menu
    # of both Designer and Linguist as that relies on Assistant being in `bin`.)
    libexec.mkpath
    Pathname.glob("#{bin}/*.app") { |app| mv app, libexec }
  end

  def caveats
    <<~EOS
      We agreed to the Qt open source license for you.
      If this is unacceptable you should uninstall.
    EOS
  end

  test do
    (testpath/"hello.pro").write <<~EOS
      QT       += core
      QT       -= gui
      TARGET = hello
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>
      #include <QDebug>

      int main(int argc, char *argv[])
      {
        QCoreApplication a(argc, argv);
        qDebug() << "Hello World!";
        return 0;
      }
    EOS

    system bin/"qmake", testpath/"hello.pro"
    system "make"
    assert_predicate testpath/"hello", :exist?
    assert_predicate testpath/"main.o", :exist?
    system "./hello"
  end
end

__END__
--- a/qtbase/src/plugins/styles/mac/qmacstyle_mac.mm
+++ b/qtbase/src/plugins/styles/mac/qmacstyle_mac.mm
@@ -4655,15 +4655,13 @@ static void setLayoutItemMargins(int left, int top, int right, int bottom, QRect
             auto frameRect = cw.adjustedControlFrame(btn->rect);
             if (sr == SE_PushButtonContents) {
                 frameRect -= cw.titleMargins();
-            } else {
+            } else if (cw.type != QMacStylePrivate::Button_SquareButton) {
                 auto *pb = static_cast<NSButton *>(d->cocoaControl(cw));
-                if (cw.type != QMacStylePrivate::Button_SquareButton) {
-                    frameRect = QRectF::fromCGRect([pb alignmentRectForFrame:pb.frame]);
-                    if (cw.type == QMacStylePrivate::Button_PushButton)
-                        frameRect -= pushButtonShadowMargins[cw.size];
-                    else if (cw.type == QMacStylePrivate::Button_PullDown)
-                        frameRect -= pullDownButtonShadowMargins[cw.size];
-                }
+                frameRect = QRectF::fromCGRect([pb alignmentRectForFrame:frameRect.toCGRect()]);
+                if (cw.type == QMacStylePrivate::Button_PushButton)
+                    frameRect -= pushButtonShadowMargins[cw.size];
+                else if (cw.type == QMacStylePrivate::Button_PullDown)
+                    frameRect -= pullDownButtonShadowMargins[cw.size];
             }
             rect = frameRect.toRect();
         }
--- a/qtbase/src/widgets/styles/qstylesheetstyle.cpp
+++ b/qtbase/src/widgets/styles/qstylesheetstyle.cpp
@@ -5821,6 +5821,7 @@ QRect QStyleSheetStyle::subElementRect(SubElement se, const QStyleOption *opt, c

     switch (se) {
     case SE_PushButtonContents:
+    case SE_PushButtonBevel:
     case SE_PushButtonFocusRect:
         if (const QStyleOptionButton *btn = qstyleoption_cast<const QStyleOptionButton *>(opt)) {
             if (rule.hasBox() || !rule.hasNativeBorder())
--- a/qtbase/tests/auto/widgets/widgets/qpushbutton/tst_qpushbutton.cpp
+++ b/qtbase/tests/auto/widgets/widgets/qpushbutton/tst_qpushbutton.cpp
@@ -67,6 +67,7 @@ private slots:
     void sizeHint();
     void taskQTBUG_20191_shortcutWithKeypadModifer();
     void emitReleasedAfterChange();
+    void hitButton();

 protected slots:
     void resetCounters();
@@ -648,5 +649,45 @@ void tst_QPushButton::emitReleasedAfterChange()
     QCOMPARE(spy.count(), 1);
 }

+/*
+    Test that QPushButton::hitButton returns true for points that
+    are certainly inside the bevel, also when a style sheet is set.
+*/
+void tst_QPushButton::hitButton()
+{
+    class PushButton : public QPushButton
+    {
+    public:
+        PushButton(const QString &text = {})
+        : QPushButton(text)
+        {}
+
+        bool hitButton(const QPoint &point) const override
+        {
+            return QPushButton::hitButton(point);
+        }
+    };
+
+    QDialog dialog;
+    QVBoxLayout *layout = new QVBoxLayout;
+    PushButton *button1 = new PushButton("Ok");
+    PushButton *button2 = new PushButton("Cancel");
+    button2->setStyleSheet("QPushButton { margin: 10px; border-radius: 4px; border: 1px solid black; }");
+
+    layout->addWidget(button1);
+    layout->addWidget(button2);
+
+    dialog.setLayout(layout);
+    dialog.show();
+    QVERIFY(QTest::qWaitForWindowExposed(&dialog));
+
+    const QPoint button1Center = button1->rect().center();
+    QVERIFY(button1->hitButton(button1Center));
+
+    const QPoint button2Center = button2->rect().center();
+    QVERIFY(button2->hitButton(button2Center));
+    QVERIFY(!button2->hitButton(QPoint(0, 0)));
+}
+
 QTEST_MAIN(tst_QPushButton)
 #include "tst_qpushbutton.moc"
