class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/2.8.0/source/quick-lint-js-2.8.0.tar.gz"
  sha256 "e432e0635f5acf1b0fc1047b2f7f21ad78ac545e29403cfc38ae0a88abd37b41"
  license "GPL-3.0-or-later"
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3cd299798bc6f1759c04610dbe3add6d9e9bba60e59de5cf77d937fa12f2e525"
    sha256 cellar: :any,                 arm64_big_sur:  "61863de8aa85e3425f4c124cc7e83acd2ba929996ab5342b08600c2805126e0f"
    sha256 cellar: :any,                 monterey:       "787d0e809422673e66b3c4b164b005bd6062a1bdecd3fd3395d26b90c1e679de"
    sha256 cellar: :any,                 big_sur:        "32e7df25a0468dde53f332980eddfb1d9eaeb15f3495dfd6c60284e2caa18e22"
    sha256 cellar: :any,                 catalina:       "51d6766400e325d23bb553d71839bd0304c32465e4c7aed81755701aed87f0ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e55c7cf77c11536d9899e7ad5b523749ebee9e623bd51913cf339bd65b920b1c"
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
