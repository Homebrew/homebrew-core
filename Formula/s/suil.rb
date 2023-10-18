class Suil < Formula
  desc "Lightweight C library for loading and wrapping LV2 plugin UIs"
  homepage "https://drobilla.net/software/suil.html"
  url "https://download.drobilla.net/suil-0.10.18.tar.xz"
  sha256 "84ada094fbe17ad3e765379002f3a0c7149b43b020235e4d7fa41432f206f85f"
  license "ISC"
  head "https://gitlab.com/lv2/suil.git", branch: "master"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?suil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "da4e96201ab8522bf7fa29606b0f173362b7559aa99b1ea23edee4c46f0d885a"
    sha256 arm64_ventura:  "c16352b240c86569da188787f15046383e4a19e1c29c43af837fcef3920e5e8b"
    sha256 arm64_monterey: "0c4d8b7e8560e0943ddec670ff4d3a67ee0875b5d277df4c3000c9944e6dca1f"
    sha256 arm64_big_sur:  "2182b7000767586fb9e95a79f56e8099eebdad2592a3a8d2aefe2c857a941415"
    sha256 sonoma:         "082717615091cc3caf9a9f2619deb24c8777a00a667e725a802ff6bc3b1bc50b"
    sha256 ventura:        "9b1422b8a975aa305885b35234a38774a764b9a19163a62ce970b43af29f3a89"
    sha256 monterey:       "934191e852bb9a873c72de4049009d1572e1258e8984deb69a7270e2a4ebba5e"
    sha256 big_sur:        "e4e4e33c56f403d0d8947c9955c44e38f488a44aee173c6776c5450b360fdb69"
    sha256 catalina:       "479de98313d7f3f58e78bc1667b1169b3a92157f5f64d2a2eb54d567dde1be33"
    sha256 x86_64_linux:   "57ddadd96885c8ba621b7f8e8538392defbf0048bd332e9ca62075a379d5872b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
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
