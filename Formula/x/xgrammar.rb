class Xgrammar < Formula
  desc "Structured generation and reasoning engine for LLMs"
  homepage "https://xgrammar.mlc.ai/"
  url "https://github.com/mlc-ai/xgrammar/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "a653eb2b372d4efe1ed6677b0f2be61b7606196052cc88f4c77ae0ca48f307fb"
  license "Apache-2.0"
  head "https://github.com/mlc-ai/xgrammar.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7d2d352576787d5c1dc36c494b1baaf535d6d701ce45d95d1d88caf217423192"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d2bd6170875e29dabf1e5eabf7cf78c70ba306c796f240b3d78ae5753e896f82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0bc8f3ebdd7018180eb7ae0c75834b91215353e2c451ce155d96d7a8c1272a21"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2c99436f1f8566baafb9f79956a51347a95fa0d3dd7cfc096a585e62a9f538aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "217f168fcbf7d4f91a0f274790e90ba40fd5d9d1a44f997f7005ebf5dd0eb93a"
  end

  depends_on "cmake" => :build
  depends_on "dlpack"

  deny_network_access!

  def install
    # `cmake/config.cmake` shadows the cache options with normal variables, so ship our own
    (buildpath/"build").mkpath
    (buildpath/"build/config.cmake").write "set(XGRAMMAR_BUILD_PYTHON_BINDINGS OFF)\n"

    # Stand in for the dlpack submodule, which the tarball does not ship
    (buildpath/"3rdparty/dlpack/include").install_symlink formula_opt_include("dlpack")/"dlpack"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # The headers are installed by the `dlpack` formula itself
    rm include/"dlpack"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <xgrammar/compiler.h>
      #include <xgrammar/matcher.h>
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
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-lxgrammar", "-o", "test"
    system "./test"
  end
end
