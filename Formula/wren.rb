class Wren < Formula
  desc "Small, fast, class-based concurrent scripting language"
  homepage "https://wren.io"
  url "https://github.com/wren-lang/wren/archive/0.3.0.tar.gz"
  sha256 "c566422b52a18693f57b15ae4c9459604e426ea64eddb5fbf2844d8781aa4eb7"

  bottle do
    cellar :any
    sha256 "d1ca917b1d503b80d73e2b2d65d07f658737cfacd4755bd4c7fe7419a4a70520" => :catalina
    sha256 "c8908d9c6a3f6ec3f80c6f384b3dbff5855639790a850fde4a7eea945ce5411a" => :mojave
    sha256 "8128fe4bbe34c39e9069ca5b03714361508b1c76c241080f53bef7bb434b4886" => :high_sierra
  end

  def install
    system "make", "-C", "projects/make.mac"
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
