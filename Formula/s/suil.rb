class Suil < Formula
  desc "Lightweight C library for loading and wrapping LV2 plugin UIs"
  homepage "https://drobilla.net/software/suil.html"
  url "https://download.drobilla.net/suil-0.10.22.tar.xz"
  sha256 "d720969e0f44a99d5fba35c733a43ed63a16b0dab867970777efca4b25387eb7"
  license "ISC"
  head "https://gitlab.com/lv2/suil.git", branch: "master"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?suil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "d72bbcdf5b36e8b6910246e266dd11530aec6985ee8471944d4a236629687b82"
    sha256 arm64_sequoia: "3a131c8b4177cec651521981be98084c9f51164cda259d8f78d110c933e22989"
    sha256 arm64_sonoma:  "aaf1ed83539d0430a42e90e4cb0aba34e226a948a3bca6cdb918aa9a8a5da0d7"
    sha256 arm64_ventura: "64c64d93ac2c688372e8c4773fb44045a0a81c24fac5bc698bf4db8a931948f1"
    sha256 sonoma:        "bc6e784d338b47e3a4e76edf8d3b4e781971c2188f120a41776db19b7459b16d"
    sha256 ventura:       "fa22d68335ca3a5337904e2a9cd8d8e3e4f285512ded9b0c65190827f9980522"
    sha256 x86_64_linux:  "a019ceaf7b2a6934baab2af852ef86aedc32559ba114d40a430b68f61c478cd3"
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
    depends_on "qt"
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
