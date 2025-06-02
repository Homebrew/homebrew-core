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
    sha256 arm64_sequoia: "b27db9a3ce79f632d05b548af8aa895cc763f16b501a9c9bdc8034e4859dea86"
    sha256 arm64_sonoma:  "529c47a29c76d87980ea9834dd2a01e2590d0adb8dc9a2a47fb82eb5a705d984"
    sha256 arm64_ventura: "bd054ff192b6136795fc419d57c5424d32e10ff8549d63429999e6fc6e85ecb4"
    sha256 sonoma:        "f22ed2c24dfd9fdd0e046c4373717a5bcd9b5934d816357814b461cc3eba1e72"
    sha256 ventura:       "28cba60e06927ded4633dedf3b1c9541e5ff8fe692df7e9d6ad0d52055f2abd4"
    sha256 x86_64_linux:  "c82fc9ca3e304f4ddab55a00cddc288ba608f5114103e22a1afb7e85d413d87c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "lv2"
  depends_on "qt@5"

  on_linux do
    depends_on "glib"
    depends_on "gtk+3"
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
