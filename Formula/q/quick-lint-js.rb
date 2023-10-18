class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/2.16.0/source/quick-lint-js-2.16.0.tar.gz"
  sha256 "bab8fce32b9f481d07bb94ce8158d6fdb8bf5200c308beb326ecbf1ecfca57f5"
  license "GPL-3.0-or-later"
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c85a5b4186a359e8bce11a1cbd797a85273dc67aa6044d4f48bdb53aa7dab7cc"
    sha256 cellar: :any,                 arm64_monterey: "3216ed7eb63ba658b274368b604701146b5b85068f3a1733d0aa65c40c6634fa"
    sha256 cellar: :any,                 arm64_big_sur:  "6d1e314a77face0c3e989477ae32cd06a1cad4ad825b83af0ead92e8d4168e16"
    sha256 cellar: :any,                 ventura:        "c23798965b8893f63d53c7a1ac5edc0441cda157b01f171120210eb058c648ce"
    sha256 cellar: :any,                 monterey:       "a4df508b28c4c416b614951aa6ec6d2692a36985b08779aaa0ca06b8eda4746f"
    sha256 cellar: :any,                 big_sur:        "1e9cfe3ced716af2acdd237b422b569f8204dace6b04a1f5260eeff63d1a205e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2109279f5aa9dc36aaaf69ae45481426d2d55f935c545261c1ca7f49c92982a"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
  depends_on "simdjson"

  fails_with :gcc do
    version "7"
    cause "requires C++17"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_TESTING=ON",
                    "-DQUICK_LINT_JS_ENABLE_BENCHMARKS=OFF",
                    "-DQUICK_LINT_JS_INSTALL_EMACS_DIR=#{elisp}",
                    "-DQUICK_LINT_JS_INSTALL_VIM_NEOVIM_TAGS=ON",
                    "-DQUICK_LINT_JS_USE_BUNDLED_GOOGLE_BENCHMARK=OFF",
                    "-DQUICK_LINT_JS_USE_BUNDLED_GOOGLE_TEST=OFF",
                    "-DQUICK_LINT_JS_USE_BUNDLED_SIMDJSON=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "ctest", "--verbose", "--parallel", ENV.make_jobs, "--test-dir", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"errors.js").write <<~EOF
      const x = 3;
      const x = 4;
    EOF
    ohai "#{bin}/quick-lint-js errors.js"
    output = `#{bin}/quick-lint-js errors.js 2>&1`
    puts output
    refute_equal $CHILD_STATUS.exitstatus, 0
    assert_match "E0034", output

    (testpath/"no-errors.js").write 'console.log("hello, world!");'
    assert_empty shell_output("#{bin}/quick-lint-js no-errors.js")
  end
end
