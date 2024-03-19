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
    sha256 arm64_sonoma:   "3786a8f72e84d526393aacf88914e0e2c8846be83237c3583293a81a4501f172"
    sha256 arm64_ventura:  "2ae1dceda234d02d9345dda24395ac7b3c23420821107aa95c919d73953ad159"
    sha256 arm64_monterey: "cabdba5ebcc04aefab86262329a739b9fe072fe514294aba5188f5d48fc2988c"
    sha256 sonoma:         "7774467a2d248fd6251bb32ff1ba996e8b1d14e53bf20b58bf7e0e4aed2719dc"
    sha256 ventura:        "73c258d4b84425e3f4644c632bef762824481cf30b5ac2b5a6183f639d05cd9a"
    sha256 monterey:       "5455af86ac9b03718c82f1b1d7b7c45060d7183dc5b186ac3dab29c46fa939b3"
    sha256 x86_64_linux:   "cd685f9ad0942a691b83de434016e1363322bf0418fb8169778e81c81e4d05a5"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "gtk+3"
  depends_on "lv2"
  depends_on "qt@5"

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
