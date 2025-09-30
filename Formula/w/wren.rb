class Wren < Formula
  desc "Small, fast, class-based concurrent scripting language"
  homepage "https://wren.io"
  url "https://github.com/wren-lang/wren/archive/refs/tags/0.4.0.tar.gz"
  sha256 "23c0ddeb6c67a4ed9285bded49f7c91714922c2e7bb88f42428386bf1cf7b339"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "8c4291a4d7ced18176f129c62108b7a2f0286501d05b23ba5f3edcc3016f69c9"
    sha256 cellar: :any,                 arm64_sequoia:  "32ef27315c3c2718071ccbe516fbdc91934eb94d2a0e5f91ec63c215efb8aea0"
    sha256 cellar: :any,                 arm64_sonoma:   "a3100038802e99ce273976dec06b8cd2239cc9146523664938107d867ad9ba60"
    sha256 cellar: :any,                 arm64_ventura:  "a56a102a2a2e336cae95c2df5bec5ddc48dcb53dd7c922ae6f19380637f6c759"
    sha256 cellar: :any,                 arm64_monterey: "c3e1412d38068f8218c7753b55468289c1602c0bc60ab2d60f45fb2bb7547dbf"
    sha256 cellar: :any,                 arm64_big_sur:  "cbe4d9028c361a3e725091eb9d15b9b040160f03508d674de3052df405691e24"
    sha256 cellar: :any,                 sonoma:         "126f8d26f864a6efb1bcddf49d492c5c9246bf3aff05b7cd58b8479e1eba83d8"
    sha256 cellar: :any,                 ventura:        "9404afe9b05d7f6c8453162417624aa4c67c1bdd13bc296353c7b3b65aec1329"
    sha256 cellar: :any,                 monterey:       "64f267fae9c817599741fa6f00121de14f18c1287df743b33c7c7567e2d5cda0"
    sha256 cellar: :any,                 big_sur:        "c54db478f8ec48d08dc4992bb8efe1308d478f20f3177513d0154460e26ad1f0"
    sha256 cellar: :any,                 catalina:       "afa48d4ceca7e0e2227bf6fd6204194de239c3b67436a46485a7563673fb4fed"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "33182bdc7645b09e96f4fdc1b7bc949b9b521e15bd6a3b78569966ba0ad132c4"
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
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lwren", "-o", "test"
    assert_equal "1 + 2 = 3", shell_output("./test").strip
  end
end
