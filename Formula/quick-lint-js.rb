class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/2.3.1/source/quick-lint-js-2.3.1.tar.gz"
  sha256 "ed13ec8a74f88bd6c981a41704dea67b98062ced45d21634e2bfb501dfa917be"
  license "GPL-3.0-or-later"
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1ff15a885e3199e0ccee296e34087887d2929753cbf8cb4c6d980b50d2cb870a"
    sha256 cellar: :any,                 arm64_big_sur:  "8768f72cb32c32a020ec21c601a1b686d88bf195f41ec2470e1d88079d03c88f"
    sha256 cellar: :any,                 monterey:       "16e0c19317848e242eee10552ab75cc94596a1e495e6775f9c41d8a9c6e0958e"
    sha256 cellar: :any,                 big_sur:        "e32929e5daea8e3a8213fc45d41677ad908de399191a874f6d48c8ddf8929e0c"
    sha256 cellar: :any,                 catalina:       "e45c8346b4606ddf5aa410c19846b1e4acb82b733be2f071e307ae2d120c5620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b6797feb098620061ad28fcfad611397344124aa20bbdf509a85532160b3333"
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
