class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/2.12.0/source/quick-lint-js-2.12.0.tar.gz"
  sha256 "202c5f55bdc1ae0f4065292a942de7957775cdd02ad200963bffe644ca7ae670"
  license "GPL-3.0-or-later"
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1045131e0b7c7d5a04393933ac1d04b8e4a4286250740d6c1aa37bf4f93aad8c"
    sha256 cellar: :any,                 arm64_monterey: "00cc306f2b5c5802a9d981a364eee39e814f538ced393aef1516736fe3c463c4"
    sha256 cellar: :any,                 arm64_big_sur:  "9e3e073470d705ab0bc152e22e9b899a095b26720897f0de8c0118ff5bab3866"
    sha256 cellar: :any,                 ventura:        "c4cffd5055b5944e5cb849a52b816c31212fab0292ba9f172cf58013cbaa107e"
    sha256 cellar: :any,                 monterey:       "46b26b514e9dcbee9cfe2d4cb6595dc5886151a47abdb01d04695478b2223346"
    sha256 cellar: :any,                 big_sur:        "ec8f2dc97abb3d5d2a311b7d9b9514a7e15313884eda6b038d619818a7fdb419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4202d7ff2142ef4b719f4db7174bcaac5781c748d511e9658be7b5de66b2c99"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
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
