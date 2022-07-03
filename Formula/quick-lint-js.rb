class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/2.6.0/source/quick-lint-js-2.6.0.tar.gz"
  sha256 "6fd402e1d0743adb9e862532e25b2be09f637d4c45cb964251ac0f52a1eb5d5c"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "15d8db79f62592d57a30c7e44559f47f9e277435978012d4c7aef96d18e99b21"
    sha256 cellar: :any,                 arm64_big_sur:  "1070818227bb3d232d8eb60985307a788cdb7a12fa45ff6943611d0dbe90e097"
    sha256 cellar: :any,                 monterey:       "627a3b38071b98820ed26fbc0edb97da23e26dc6c18b50b4b73bbf5128c74ee9"
    sha256 cellar: :any,                 big_sur:        "719810eb7d0d484621b99c4205e011bf8990423d8aa5f48d14475a392ce1adec"
    sha256 cellar: :any,                 catalina:       "6d572f276446f65e2b95b55ba0ad04b6a45f3a6757d95d085853e6dcbab0eb02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "002033d75bd7c7ac89a24a6843605b6ec55aa4125f254e395181bec393cc752f"
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
