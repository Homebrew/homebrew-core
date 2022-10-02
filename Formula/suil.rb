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
    sha256 arm64_monterey: "e5a25182fc6bc52b88a470248e4263e4744b9d2df31c36d8e903523c19832b7d"
    sha256 arm64_big_sur:  "dfcc9301dca83593d4556d36b29411fa658ced02c59bd5a23b38cd0fbae5805f"
    sha256 monterey:       "28cde799db29ed771bf7d525551c1cb65b514b66d5ff4a9e5358f31fd3009466"
    sha256 big_sur:        "054500679837fed2d069828244191e3da85421aa5c4773b5f28ce44993f1f669"
    sha256 catalina:       "3c2d95382b91fb20e3cf03d64c5695a92121f93f7bd3b8928f1928d092c211e8"
    sha256 x86_64_linux:   "2b5f51754e05f0444115cdc6e5da108f59871d1abf013b2619d897c1f88c83fb"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.10" => :build
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
