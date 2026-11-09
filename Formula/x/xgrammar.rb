class Xgrammar < Formula
  desc "Structured generation and reasoning engine for LLMs"
  homepage "https://xgrammar.mlc.ai/"
  url "https://github.com/mlc-ai/xgrammar/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "a653eb2b372d4efe1ed6677b0f2be61b7606196052cc88f4c77ae0ca48f307fb"
  license "Apache-2.0"
  head "https://github.com/mlc-ai/xgrammar.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "921e5a484331059d72fb152ad0c12356c57238b40a36ad9e596acd2daf1b21fb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5309800d87a4a4b08070443761f873dd484e20a42774b302f59ece483e1d6a26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9b5bf98c998e84eac0bf7b090c5f988291a10efa780b2d181f502544e58b6ea8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "587161526b68d13c6e9625b30e10e9d64ed634ca477913bc22ef5bb63d04c69c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1790cc96475ae4122e6e65660846c215c0fae90b2ca71979799c7143f1bfecd0"
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
