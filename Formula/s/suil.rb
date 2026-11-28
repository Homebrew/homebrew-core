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
    rebuild 1
    manifest_sha256 "537e064d97191146b93f4a3241af0b220de3ff6ba20f1562413aaa0420d77df1"
    sha256 arm64_golden_gate: "5e61204661ea0fb05a4cfd25e17a82727816a0b916f50cb2de73c3d239789f4c"
    sha256 arm64_tahoe:       "f1114139ad9a565503ce1b1605c8f8fca56912801de06cb08629222d29ab690b"
    sha256 arm64_sequoia:     "93c11803d5ebdd53cdba26f7c0c01ed16ff73b8b186a87b78c2636bd6f5ebaf5"
    sha256 arm64_linux:       "923b3b4a5ec4a19a8e2b9983940e54f4dc45a4a0a985c5a1fe489a4d87d9253a"
    sha256 x86_64_linux:      "ea9b30c9a3054fe029fe38a143ec0e5e23661396b990bfd62dcc99b90d7f6514"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "lv2"

  on_linux do
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "qtbase"
  end

  deny_network_access!

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
    lv2 = formula_opt_include("lv2")
    system ENV.cc, "test.c", "-I#{lv2}", "-I#{include}/suil-0", "-L#{lib}", "-lsuil-0", "-o", "test"
    system "./test"
  end
end
