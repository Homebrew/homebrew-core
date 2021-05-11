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
    rebuild 2
    sha256 cellar: :any, arm64_big_sur: "7ef952fd5a8e55ff56f3d2e5a56434e105dbb9b983fa4996beac0105408a036c"
    sha256 cellar: :any, big_sur:       "af31e3436d816900efe9a6cefdf4934abaeab26e4624216e4a2e066b95459a35"
    sha256 cellar: :any, catalina:      "c975932fca6aa5e23a331542d2d905d9b53af0b32c44fa9489c9b7bbca666b79"
    sha256 cellar: :any, mojave:        "12270fe77e376fe51eec1ceb2f113b84edcf3bfe37ef1c6dbcbf313459488536"
  end

  def install
    on_macos do
      system "make", "-C", "projects/make.mac"
    end
    on_linux do
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
