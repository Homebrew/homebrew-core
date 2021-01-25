class Wren < Formula
  desc "Small, fast, class-based concurrent scripting language"
  homepage "https://wren.io"
  url "https://github.com/wren-lang/wren/archive/0.3.0.tar.gz"
  sha256 "c566422b52a18693f57b15ae4c9459604e426ea64eddb5fbf2844d8781aa4eb7"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "d9bad5cf08d732c215d5272618bdbe79ea9b5b8a57ab5879fdcc21bdd3ff073f" => :big_sur
    sha256 "a60ed53ad23d2b9e4a1b8bcd59e4f48e2e6458ce23d61377add956c7c9128a8b" => :arm64_big_sur
    sha256 "21bb30d077f3de93293d6e6f3c41e8f923e6de7d8d04df2f48c7378f76b3d16f" => :catalina
    sha256 "d3837f28ed556d33753beb658f22b197f0afdb2aac3b30de26b2859397123d51" => :mojave
    sha256 "529a384d6d1665dd269ef7b6e8ea61f1edccddd5478ce82ec30839346af3d3b5" => :high_sierra
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
