class Suil < Formula
  desc "Lightweight C library for loading and wrapping LV2 plugin UIs"
  homepage "https://drobilla.net/software/suil.html"
  url "https://download.drobilla.net/suil-0.10.26.tar.xz"
  sha256 "62808916602c47d201a1ec2d246323a8048243f2bf972f859f0db1db4662ee43"
  license "ISC"
  head "https://gitlab.com/lv2/suil.git", branch: "main"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?suil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "adce2989ab987d21cf92671496284df3396f22dd113495c8ba44e2bbe90c22fb"
    sha256 arm64_sequoia: "3465540e13410f3444375c0588c26c58d947aa1c5781801252f43f89406f8eff"
    sha256 arm64_sonoma:  "4e500b8273217d5c1f0eccf6f3d8d34e8ff1845342c001c3ea95a104a206007a"
    sha256 sonoma:        "6a071ed376235a2f02b4a7a085b8eba6af48835aeccec1f4d3a44dd874a0e543"
    sha256 arm64_linux:   "f33735b4417b37962f04cc8f6d4f199037af19d6ff15d2273e5784fa98efbfd3"
    sha256 x86_64_linux:  "96d50ae9d442fbc64791d9e12ea1fe44fb1aa0f3082bb37bcbff908e355c5e3f"
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
