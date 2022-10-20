class Wren < Formula
  desc "Small, fast, class-based concurrent scripting language"
  homepage "https://wren.io"
  url "https://github.com/wren-lang/wren/archive/0.4.0.tar.gz"
  sha256 "23c0ddeb6c67a4ed9285bded49f7c91714922c2e7bb88f42428386bf1cf7b339"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c3e1412d38068f8218c7753b55468289c1602c0bc60ab2d60f45fb2bb7547dbf"
    sha256 cellar: :any,                 arm64_big_sur:  "cbe4d9028c361a3e725091eb9d15b9b040160f03508d674de3052df405691e24"
    sha256 cellar: :any,                 monterey:       "64f267fae9c817599741fa6f00121de14f18c1287df743b33c7c7567e2d5cda0"
    sha256 cellar: :any,                 big_sur:        "c54db478f8ec48d08dc4992bb8efe1308d478f20f3177513d0154460e26ad1f0"
    sha256 cellar: :any,                 catalina:       "afa48d4ceca7e0e2227bf6fd6204194de239c3b67436a46485a7563673fb4fed"
    sha256 cellar: :any,                 mojave:         "f55d068b6db418338ba1f4622b75d5c36b2b3462e27f28c0844e32c980b6b881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9129580dd56d4ad4ad66ac59e1d43533b54816936fc18d0216a445d576598e0"
  end

  def install
    if OS.mac?
      system "make", "-C", "projects/make.mac"
    else
      system "make", "-C", "projects/make"
    end
    lib.install Dir["lib/*"]
    include.install Dir["src/include/*"]
    pkgshare.install "example"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <stdio.h>
      #include "wren.h"

      int main()
      {
        WrenConfiguration config;
        wrenInitConfiguration(&config);
        WrenVM* vm = wrenNewVM(&config);
        WrenInterpretResult result = wrenInterpret(vm, "test", "var result = 1 + 2");
        assert(result == WREN_RESULT_SUCCESS);
        wrenEnsureSlots(vm, 0);
        wrenGetVariable(vm, "test", "result", 0);
        printf("1 + 2 = %d\\n", (int) wrenGetSlotDouble(vm, 0));
        wrenFreeVM(vm);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lwren", "-o", "test"
    assert_equal "1 + 2 = 3", shell_output("./test").strip
  end
end
