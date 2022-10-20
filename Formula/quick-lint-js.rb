class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/2.10.0/source/quick-lint-js-2.10.0.tar.gz"
  sha256 "e5b480dc3ebb68ae767afbf6b35e340c0fe75c0730908a078386fdedfc0874c7"
  license "GPL-3.0-or-later"
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "49f6234901bff48ac7655e4ccd3ebe3537c04877d3bc5add5e7aabb9964df3fb"
    sha256 cellar: :any,                 arm64_big_sur:  "75becb2742c84477cc3d455298e728381e0cde0c10e3ed7c0f2880d417f2cd57"
    sha256 cellar: :any,                 monterey:       "ef1b51d496634b92dbe8cf78cdd5f4de38c5d1ac69e9ae1e682791ce2c343344"
    sha256 cellar: :any,                 big_sur:        "6ae879827826b5dab7d724c8ef6c00df109c613116029de5207c3e1c52247d57"
    sha256 cellar: :any,                 catalina:       "4cc0d70ce91b9ab13fac0123a07d8c9fed4722ca83539291e83606214ae466b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a00b52f5ac8787a3f03244ec27fc93cbfb72409cc87801cfac70f98fb98404de"
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
