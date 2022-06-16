class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/2.6.0/source/quick-lint-js-2.6.0.tar.gz"
  sha256 "6fd402e1d0743adb9e862532e25b2be09f637d4c45cb964251ac0f52a1eb5d5c"
  license "GPL-3.0-or-later"
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3f46f8c842da6f289ce4591834e123d8b9f1793f476aa390e7fc2fdbb7fbe2b6"
    sha256 cellar: :any,                 arm64_big_sur:  "6f2611e37d22e624c776bb6b0ad12bc9df97ca0ba85f4fa52064f3cd696dedaa"
    sha256 cellar: :any,                 monterey:       "64415bc4ad16f746182e6b2216b7ff1872d3b1db7a098a572abc3b5a2bfaac66"
    sha256 cellar: :any,                 big_sur:        "fb8865890a15f4bb4b4f7afc056c0bd7baedf0218458c9479643e9e813e318d5"
    sha256 cellar: :any,                 catalina:       "ae1f9796eed886ea6b46faccdd5b1b3cea630d6b4732f8e42e9b1d90d42107f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "527e2a20b74919de975ca9e2dc8cf1fbfcc39baf38c979e67ea61ddbf8e56ac5"
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
