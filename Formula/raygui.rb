class Raygui < Formula
  desc "Simple and easy-to-use immediate-mode gui library"
  homepage "https://github.com/raysan5/raygui"
  url "https://github.com/raysan5/raygui/archive/refs/tags/3.1.tar.gz"
  sha256 "4c7d63df44ef1c6a0ddc52b85f3ea32dd480ac764bf2a210cdd6f016a63b5721"
  license "Zlib"

  depends_on "cmake" => :build
  depends_on "raylib"

  def install
    system "cmake", "-S", "projects/CMake", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #define RAYGUI_IMPLEMENTATION
      #include <raygui.h>
      int main() {
        GuiGetStyle(DEFAULT, TEXT_SIZE);
        return 0;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-lraylib", "-L#{Formula["raylib"].opt_lib}", "-I#{include}"
    system "./test"
  end
end
