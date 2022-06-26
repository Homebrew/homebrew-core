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
    sha256 arm64_monterey: "ec23ca1cf049b1bb558df5ae4921582583789f715cfa2d00e7544c21d578959f"
    sha256 arm64_big_sur:  "324f6f636659de1d671ef38a153fa5fab53ef9d65f44005f89c86f980e480c3e"
    sha256 monterey:       "bfde25d0fb2f1b244bf05ec2076dccb916d28c20518152306508905e0898ff09"
    sha256 big_sur:        "34960235e7e2ea7cc3d2676c356058bb63a5f48605582a367c45df3fca1af7ba"
    sha256 catalina:       "7b876e50f677d553cd2736b397d6393f43319b7a695fe2fc9460cc9c73f63afe"
    sha256 x86_64_linux:   "44cdafe1344964b295ed7bc86dc9a96cc73ccb86aab8bc44adb4dd93cfa187ee"
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
