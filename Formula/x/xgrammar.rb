class Xgrammar < Formula
  desc "Structured generation and reasoning engine for LLMs"
  homepage "https://xgrammar.mlc.ai/"
  url "https://github.com/mlc-ai/xgrammar/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "c336102a5c2d644bfa52ff6881016e002c30bac05143d038f03f841f6d1ddc47"
  license "Apache-2.0"
  head "https://github.com/mlc-ai/xgrammar.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "40241cdb1349e097bdf2b1f3c2c02ab0cd95068374e2d0c085c6c7ef8cc5638f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7194ffdcd5ba6984e3faea419f8261d35b6362f3a9fe0fa2a0cd8b5e1d36a04c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a3093f22599b3dc3d9d2c7092cc526ac64e491dbb21a80915cba1a4e522d8821"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f6f51c28589c9e5b98f1ba59e20a180a5eb8527aa95479307cd8d001e5add0fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "35f782fc55d7c56f338bf7d5777378a2e25b73396d3621cc33c40cfda9fab5a7"
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
