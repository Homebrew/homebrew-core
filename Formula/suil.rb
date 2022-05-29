class Suil < Formula
  desc "Lightweight C library for loading and wrapping LV2 plugin UIs"
  homepage "https://drobilla.net/software/suil.html"
  url "https://download.drobilla.net/suil-0.10.12.tar.bz2"
  sha256 "daa763b231b22a1f532530d3e04c1fae48d1e1e03785e23c9ac138f207b87ecd"
  license "ISC"
  head "https://gitlab.com/lv2/suil.git", branch: "master"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?suil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "4b952357f77ca23c77da7b02bd5b95da858d74e33378272a7bf7c63e759fb0af"
    sha256 arm64_big_sur:  "11af96a8cd470b08da0bd49cb3b620ae81d89e9589c5ed44a533e2cb93d5133f"
    sha256 monterey:       "ce9decde67d416caaae2d8e0be74eb1a2f0497d856f6a4e40d13a84c71ebd3b2"
    sha256 big_sur:        "02a8eed42b15c099954dce4741c71b0e5f9ae652fce48921e4920a3efc779e01"
    sha256 catalina:       "4a74f4c1cbf9b1e67c7fbda45e5ca67b5163757b70ee62c33a7e66b136a2d4c1"
    sha256 mojave:         "2bc87e39cf2cb0a66c983c01834d39c2f1cccdddbe4db28331e0dcb6cf64c3fb"
    sha256 x86_64_linux:   "b652f25be19c7044ef7f11818488054459a23719afe5cca1118be8a9dfac1547"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "gtk+"
  depends_on "gtk+3"
  depends_on "lv2"
  depends_on "qt@5"

  # Fix build issue, remove in next release
  # upstream commit ref, https://github.com/lv2/suil/commit/7183178b8e35b9a05f2a90e1d091b34c5f846ef5
  patch :DATA

  def install
    ENV.cxx11
    ENV.prepend_path "PATH", Formula["python@3.10"].libexec/"bin"
    args = [
      "--prefix=#{prefix}",
      "--gtk3-lib-name=#{shared_library("libgtk-3.0")}",
    ]
    if OS.mac?
      args += [
        "--no-x11",
        "--gtk2-lib-name=#{shared_library("libgtk-quartz-2.0.0")}",
      ]
    else
      args << ["--gtk2-lib-name=#{shared_library("libgtk-x11-2.0")}"]
    end
    system "./waf", "configure", *args
    system "./waf", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <suil/suil.h>

      int main()
      {
        return suil_ui_supported("my-host", "my-ui");
      }
    EOS
    lv2 = Formula["lv2"].opt_include
    system ENV.cc, "test.c", "-I#{lv2}", "-I#{include}/suil-0", "-L#{lib}", "-lsuil-0", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/src/gtk2_in_qt5.cpp b/src/gtk2_in_qt5.cpp
index a5c98f1..47c8271 100644
--- a/src/gtk2_in_qt5.cpp
+++ b/src/gtk2_in_qt5.cpp
@@ -41,6 +41,7 @@ SUIL_DISABLE_GTK_WARNINGS
 #include <gtk/gtk.h>
 SUIL_RESTORE_WARNINGS

+#include <cstdint>
 #include <cstdlib>

 extern "C" {
@@ -95,8 +96,7 @@ wrapper_wrap(SuilWrapper* wrapper, SuilInstance* instance)
   gtk_container_add(GTK_CONTAINER(plug), widget);
   gtk_widget_show_all(plug);

-  const WId wid =
-    static_cast<WId>(gtk_plug_get_id(reinterpret_cast<GtkPlug*>(plug)));
+  const WId wid = (WId)gtk_plug_get_id(GTK_PLUG(plug));

   QWindow* window = QWindow::fromWinId(wid);
   QWidget* container =
diff --git a/src/qt5_in_gtk.cpp b/src/qt5_in_gtk.cpp
index 6277daa..1c614c7 100644
--- a/src/qt5_in_gtk.cpp
+++ b/src/qt5_in_gtk.cpp
@@ -125,7 +125,7 @@ suil_qt_wrapper_realize(GtkWidget* w, gpointer)
 {
   SuilQtWrapper* const wrap = SUIL_QT_WRAPPER(w);
   GtkSocket* const     s    = GTK_SOCKET(w);
-  const WId            id   = static_cast<WId>(gtk_socket_get_id(s));
+  const WId            id   = (WId)gtk_socket_get_id(s);

   wrap->qembed->winId();
   wrap->qembed->windowHandle()->setParent(QWindow::fromWinId(id));
