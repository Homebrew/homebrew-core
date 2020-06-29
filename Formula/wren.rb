class Wren < Formula
  desc "Small, fast, class-based concurrent scripting language"
  homepage "https://wren.io"
  url "https://github.com/wren-lang/wren/archive/0.3.0.tar.gz"
  sha256 "c566422b52a18693f57b15ae4c9459604e426ea64eddb5fbf2844d8781aa4eb7"

  def install
    cd "projects/make.mac" do
      system "make"
    end
    lib.install Dir["lib/*"]
    include.install Dir["src/include/*"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <wren.h>

      int main()
      {
        WrenConfiguration config;
        wrenInitConfiguration(&config);
        WrenVM* vm = wrenNewVM(&config);
        WrenInterpretResult result = wrenInterpret(vm, "test", "1 + 2");
        assert(result == WREN_RESULT_SUCCESS);
        wrenFreeVM(vm);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lwren", "-o", "test"
    system "./test"
  end
end
