class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/3.2.0/source/quick-lint-js-3.2.0.tar.gz"
  sha256 "f17b39726622637946136076c406e89d3a98ae363d5e3c2a93ab1139bf0e828d"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "684ea752246efb50fe3c143434d9e0659f3838325b8e9a82b12e8d74dd87171b"
    sha256 cellar: :any,                 arm64_ventura:  "28273a5f14474f69289bead2122afd55936d3cdec961007dd4c8c32f573435ce"
    sha256 cellar: :any,                 arm64_monterey: "6221c492b1521579a5c0c916d1d2376d9069537ab558d7c475d23e6b0d176a89"
    sha256 cellar: :any,                 sonoma:         "fa27c44cdcc83e94f5b62d862d182cd662b18411291832ddd8c1454fa9c5a541"
    sha256 cellar: :any,                 ventura:        "3376f7a5fbba018cee99ba40c69d7db8660e3ac3e67742a4cbe4b0c555d8a0ed"
    sha256 cellar: :any,                 monterey:       "3b716c8ed3460b71a1d79e6a2162f77023765037c881a1fa4115d8f8b27c1c7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "970aa31fd1b6499e8c107d179c44bc833c717226962c549365a92bfb7f0f843b"
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
