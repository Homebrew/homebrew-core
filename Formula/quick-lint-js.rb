class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/2.7.0/source/quick-lint-js-2.7.0.tar.gz"
  sha256 "722a41b7c5521b2dd483b86ece20dfded6a13b8c8894e9ef2902f2a70c4735ff"
  license "GPL-3.0-or-later"
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "12108ca1f7680f37d5554e167688cc8b3dcc45d3218a5ead3aaa3368d00933b6"
    sha256 cellar: :any,                 arm64_big_sur:  "b58448d800e585607b1601df169442dbfb61bc533f38f01f294453571fd7615e"
    sha256 cellar: :any,                 monterey:       "69cd1977b006efe350c56d4895547f7302141a75e49f056c9b904cd78a01af2e"
    sha256 cellar: :any,                 big_sur:        "eca1f6d79c2d65dce07d27cc2a63b5d2646f728a31e37c27dd5e3757b71aed0e"
    sha256 cellar: :any,                 catalina:       "63625efae03df8562639e75cd354169d60909da71f5f817fb149e65332c37589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "549dbff26a0c88ac3f5f986ccdf570976982171195a4a928eb460bfc546bb498"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "simdjson"

  on_linux do
    # Use Homebrew's C++ compiler in case the host's C++
    # compiler is too old.
    depends_on "gcc"
  end

  # quick-lint-js requires some C++17 features, thus
  # requires GCC 8 or newer.
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_TESTING=ON",
                    "-DQUICK_LINT_JS_ENABLE_BENCHMARKS=OFF",
                    "-DQUICK_LINT_JS_INSTALL_EMACS_DIR=#{elisp}",
                    "-DQUICK_LINT_JS_INSTALL_VIM_NEOVIM_TAGS=ON",
                    "-DQUICK_LINT_JS_USE_BUNDLED_BOOST=OFF",
                    "-DQUICK_LINT_JS_USE_BUNDLED_GOOGLE_BENCHMARK=OFF",
                    "-DQUICK_LINT_JS_USE_BUNDLED_GOOGLE_TEST=OFF",
                    "-DQUICK_LINT_JS_USE_BUNDLED_SIMDJSON=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    chdir "build" do
      system "ctest", "-V"
    end
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
