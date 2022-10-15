class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/2.10.0/source/quick-lint-js-2.10.0.tar.gz"
  sha256 "e5b480dc3ebb68ae767afbf6b35e340c0fe75c0730908a078386fdedfc0874c7"
  license "GPL-3.0-or-later"
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "043065f6f3024baf473d8849bbecab10322c3713568a84f11d8081f306e3baf0"
    sha256 cellar: :any,                 arm64_big_sur:  "fc16f83d3915136c33c80a59836483279aba59b1ec412052aea5e597074f1eb8"
    sha256 cellar: :any,                 monterey:       "ab916d4379fcb4bdea23b603c8edd1f90fa5edc35dfb2ef4e49384ed71316462"
    sha256 cellar: :any,                 big_sur:        "f78800b0fb07d37844db0acab53aa5da1b68372876f256d92b9ff913fae664de"
    sha256 cellar: :any,                 catalina:       "62e1e777f79ac8a5fcdd727b828063003971e4c5e89ea50986b379ca41d59b53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68e45193bc1ac765054c02a02c868b296943dc0debcd48cd7318ec3df072ff1a"
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
