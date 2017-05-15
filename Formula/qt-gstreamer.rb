class QtGstreamer < Formula
  desc "C++ bindings for GStreamer with a Qt-style API"
  homepage "https://gstreamer.freedesktop.org/modules/qt-gstreamer.html"
  url "https://gstreamer.freedesktop.org/src/qt-gstreamer/qt-gstreamer-1.2.0.tar.xz"
  sha256 "9f3b492b74cad9be918e4c4db96df48dab9c012f2ae5667f438b64a4d92e8fd4"
  head "https://anongit.freedesktop.org/git/gstreamer/qt-gstreamer.git"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "boost"
  depends_on "glib"
  depends_on "gstreamer"
  depends_on "gst-plugins-base"
  depends_on "qt5"

  # QtGStreamer won't build on case-insensitive file systems because
  # its "Memory" header collides with stl's "memory" header.
  # https://bugzilla.gnome.org/show_bug.cgi?id=763201
  patch do
    url "https://github.com/detrout/qt-gstreamer/pull/7.patch"
    sha256 "50ef0b99bf559586fc6519133fd3d47924685cd5a2dfe55d177ee794bd9f43ea"
  end

  def install
    args = std_cmake_args + %W[
      -DQT_VERSION=5
      -DUSE_GST_PLUGIN_DIR=OFF
      -DUSE_QT_PLUGIN_DIR=OFF
      -DCMAKE_CXX_FLAGS=-I#{Formula["gstreamer"].opt_lib}/gstreamer-1.0/include
    ]
    system "cmake", *args
    system "make", "install"
  end

  test do
    (testpath/"main.cpp").write <<-EOS.undent
      #include <QGst/Init>
      int main() { QGst::init(); return 0; }
    EOS

    system ENV.cxx,
      "-I#{Formula["qt5"].opt_include}",
      "-I#{include}/Qt5GStreamer",
      "main.cpp", "-o", "main", "-L#{lib}", "-lQt5GStreamer-1.0"
    system "./main"
  end
end
