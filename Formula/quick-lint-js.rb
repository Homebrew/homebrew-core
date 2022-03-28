class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/2.3.1/source/quick-lint-js-2.3.1.tar.gz"
  sha256 "ed13ec8a74f88bd6c981a41704dea67b98062ced45d21634e2bfb501dfa917be"
  license "GPL-3.0-or-later"
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "068ff052c6ab43ae019379c890821ea5ece5f25fb9355d1054d61772f8f0940e"
    sha256 cellar: :any,                 arm64_big_sur:  "4f32caf43e3b1572bd8677701c53f5b64acfefbaf8b6094d6ac336101050a2a6"
    sha256 cellar: :any,                 monterey:       "b74b488628c15250a8de24dfe491230ce1873fd5d97e9813f3ac1da4b6457d8f"
    sha256 cellar: :any,                 big_sur:        "3b8f8a4a3f8994abd7183ee3040d4c69a84ac80794f5513b424de0453264742f"
    sha256 cellar: :any,                 catalina:       "c1599140edba8a88067a7161b032f791f70b307250886b7fc8126a880ac38097"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8aa0765fed21af34cc50c4136589359c54c2298371a406cee74dc43bfa22e99f"
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
