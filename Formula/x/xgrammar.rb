class Xgrammar < Formula
  desc "Structured generation and reasoning engine for LLMs"
  homepage "https://xgrammar.mlc.ai/"
  url "https://github.com/mlc-ai/xgrammar.git",
      tag:      "v0.2.7",
      revision: "82505d0d987c36a4209fb3d8571cf6b0f28b5acd"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/mlc-ai/xgrammar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "cmake" => :build

  def install
    # The in-tree default config shadows -DXGRAMMAR_BUILD_PYTHON_BINDINGS=OFF
    # with a normal variable; neutralize it so the cache option takes effect.
    inreplace "cmake/config.cmake", "set(XGRAMMAR_BUILD_PYTHON_BINDINGS ON)", ""

    system "cmake", "-S", ".", "-B", "build", "-DXGRAMMAR_BUILD_PYTHON_BINDINGS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <xgrammar/compiler.h>
      #include <xgrammar/tokenizer_info.h>

      #include <cassert>
      #include <string>
      #include <vector>

      int main() {
        std::vector<std::string> vocab = {"{", "}", ":", ",", "0", "1"};
        xgrammar::TokenizerInfo tokenizer(vocab);
        xgrammar::GrammarCompiler compiler(tokenizer, 1, false, -1);
        auto grammar = compiler.CompileBuiltinJSONGrammar();
        assert(grammar.MemorySizeBytes() > 0);
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17",
                    "-I#{include}", "-L#{lib}", "-lxgrammar",
                    "-o", "test"
    system "./test"
  end
end
