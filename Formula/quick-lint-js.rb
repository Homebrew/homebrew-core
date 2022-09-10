class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/2.9.0/source/quick-lint-js-2.9.0.tar.gz"
  sha256 "b0010e2025c3250106df9c2cd2aa67f4643c037159c2f05ba97cbc9b02b04837"
  license "GPL-3.0-or-later"
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e829b743179adba4839d6dcb23221a01bc1c473afe2033c4b0b324998cbefedb"
    sha256 cellar: :any,                 arm64_big_sur:  "3911941557711252f7b12a524807edc354d2abaf4f2306a1f035ed2cd07e4cc9"
    sha256 cellar: :any,                 monterey:       "349970456ff1f94dc70d21f466c7db4efb65366741d0b15f2a5f095da397b144"
    sha256 cellar: :any,                 big_sur:        "e5b16442309306498aded07542bff7eef8abaa7c75b0939699e94960cf78b266"
    sha256 cellar: :any,                 catalina:       "022aac5626b20882aac39adfc4c5b9daba54fb679dd76b9db112bff1374033f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf8465c87fb1027b49eb0df5cf113c2bce08512a0e39a37dd95b79cbe913850b"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "simdjson"

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
