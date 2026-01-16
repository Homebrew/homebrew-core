class Suil < Formula
  desc "Lightweight C library for loading and wrapping LV2 plugin UIs"
  homepage "https://drobilla.net/software/suil.html"
  url "https://download.drobilla.net/suil-0.10.24.tar.xz"
  sha256 "0d15d407c8b1010484626cb63b3317ba0a012edf3308b66b0f7aa389bd99603b"
  license "ISC"
  head "https://gitlab.com/lv2/suil.git", branch: "main"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?suil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "5ba107b27850aa4ac9ce801a0f86dedaa6c240f1465597ead8eb39ebb5c9ca40"
    sha256 arm64_sequoia: "af8273518f26d5b40b5f6c464278447d1456c3a2fe9da9f41276a2f9ab859835"
    sha256 arm64_sonoma:  "83a95a87004236126ecb3e75a77ea143de04ab07ba39a292c587f230ec0aa639"
    sha256 sonoma:        "be76ab51d343f69d60e67b17ded41dbdce0221d305d067c22372df0b09993b36"
    sha256 arm64_linux:   "ba3f129c5feb84f0850590d4256cc96397e2cde3b51530aaf59019e26a2f4c09"
    sha256 x86_64_linux:  "a431526998979245433c406208fd317a120bec86f323d176e7c5a063197349a9"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "lv2"

  on_macos do
    # Can undeprecate if new release with Qt 6 support is available.
    # Alternatively can just build direct X11 wrapper (libsuil_x11.dylib)
    # Issue ref: https://gitlab.com/lv2/suil/-/issues/11
    deprecate! date: "2026-05-19", because: "needs end-of-life Qt 5"

    depends_on "qt@5" # cocoa still needs Qt5
  end

  on_linux do
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "qtbase"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <suil/suil.h>

      int main()
      {
        return suil_ui_supported("my-host", "my-ui");
      }
    C
    lv2 = Formula["lv2"].opt_include
    system ENV.cc, "test.c", "-I#{lv2}", "-I#{include}/suil-0", "-L#{lib}", "-lsuil-0", "-o", "test"
    system "./test"
  end
end
