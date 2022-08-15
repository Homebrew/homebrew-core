class Suil < Formula
  desc "Lightweight C library for loading and wrapping LV2 plugin UIs"
  homepage "https://drobilla.net/software/suil.html"
  license "ISC"
  head "https://gitlab.com/lv2/suil.git", branch: "master"

  stable do
    url "https://download.drobilla.net/suil-0.10.16.tar.xz"
    sha256 "bc9f36c13863e70fd65bf7134afc2b7b141e9ca4b279590efae1d4b25f4211f9"

    # remove in next version
    patch do
      url "https://github.com/lv2/suil/commit/ecebfdb35fd8af72dc918ff34ae3f3366521925d.patch?full_index=1"
      sha256 "d12cc51870da6009555e8f40fddd64931b68e6e09362224eec0ee227d97fe62d"
    end
  end

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

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.10" => :build
  depends_on "gtk+"
  depends_on "gtk+3"
  depends_on "lv2"
  depends_on "qt@5"

  def install
    system "meson", "build", *std_meson_args
    system "meson", "compile", "-C", "build"
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
