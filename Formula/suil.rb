class Suil < Formula
  desc "Lightweight C library for loading and wrapping LV2 plugin UIs"
  homepage "https://drobilla.net/software/suil.html"
  url "https://download.drobilla.net/suil-0.10.10.tar.bz2"
  sha256 "750f08e6b7dc941a5e694c484aab02f69af5aa90edcc9fb2ffb4fb45f1574bfb"
  license "ISC"
  revision 1
  head "https://gitlab.com/lv2/suil.git", branch: "master"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?suil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "4b952357f77ca23c77da7b02bd5b95da858d74e33378272a7bf7c63e759fb0af"
    sha256 arm64_big_sur:  "11af96a8cd470b08da0bd49cb3b620ae81d89e9589c5ed44a533e2cb93d5133f"
    sha256 big_sur:        "02a8eed42b15c099954dce4741c71b0e5f9ae652fce48921e4920a3efc779e01"
    sha256 catalina:       "4a74f4c1cbf9b1e67c7fbda45e5ca67b5163757b70ee62c33a7e66b136a2d4c1"
    sha256 mojave:         "2bc87e39cf2cb0a66c983c01834d39c2f1cccdddbe4db28331e0dcb6cf64c3fb"
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "gtk+3"
  depends_on "lv2"
  depends_on "qt@5"

  # Disable qt5_in_gtk3 because it depends upon X11
  # Can be removed if https://gitlab.com/lv2/suil/-/merge_requests/1 is merged
  patch do
    url "https://gitlab.com/lv2/suil/-/commit/33ea47e18ddc1eb384e75622c0e75164d351f2c0.diff"
    sha256 "2f335107e26c503460965953f94410e458c5e8dd86a89ce039f65c4e3ae16ba7"
  end

  def install
    ENV.cxx11
    system "./waf", "configure", "--prefix=#{prefix}", "--no-x11",
        "--gtk2-lib-name=#{shared_library("libgtk-quartz-2.0.0")}", "--gtk3-lib-name=#{shared_library("libgtk-3.0")}"
    system "./waf", "install"
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
    system ENV.cc, "-I#{lv2}", "-I#{include}/suil-0", "-L#{lib}", "-lsuil-0", "test.c", "-o", "test"
    system "./test"
  end
end
