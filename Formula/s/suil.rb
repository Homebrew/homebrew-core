class Suil < Formula
  desc "Lightweight C library for loading and wrapping LV2 plugin UIs"
  homepage "https://drobilla.net/software/suil.html"
  url "https://download.drobilla.net/suil-0.10.20.tar.xz"
  sha256 "334a3ed3e73d5e17ff400b3db9801f63809155b0faa8b1b9046f9dd3ffef934e"
  license "ISC"
  head "https://gitlab.com/lv2/suil.git", branch: "master"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?suil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "3f7bb51baf30546a842c6aff377b19401598005151e2f488fc1551e4e9b612e9"
    sha256 arm64_sonoma:  "5da5e7391da7c919b62dbbd8204ac6c45f3a6289e64d8997462bd7a98622ef46"
    sha256 arm64_ventura: "845d4606abee75ca9ac8dc28dafd3a1a612c0008db81f52036ce1c83797420ee"
    sha256 sonoma:        "f60c8293ada96ce3202490d5de286dea7d4f85ce121f73ea8a96c573813a7fb4"
    sha256 ventura:       "2bca4490ee90cec539c35dce0091fce8d0b403ac518c20cd144bf1766a45c8e6"
    sha256 x86_64_linux:  "7431c0fdf1c6610b7b901d73fa7701da649b0b612f30617853e19be51343ec1e"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
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
