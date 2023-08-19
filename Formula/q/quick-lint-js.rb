class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/2.15.0/source/quick-lint-js-2.15.0.tar.gz"
  sha256 "2e3935d4433d3699638f7b82a88058fbd6f33da64f065412e23ded65b4797f1a"
  license "GPL-3.0-or-later"
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "acb5b5e0c65d0c5fa8de3ac30a38099bc2eaf6d7fb64364ef34278fcf657b5b2"
    sha256 cellar: :any,                 arm64_monterey: "f6e244939496b2e6bf45cbd512a81eb6464120be4577fea46706e2beafef7cd5"
    sha256 cellar: :any,                 arm64_big_sur:  "0fd8239197cade72277b56badfec43dcc83f14780ad27d5eb432c05dd6be5eae"
    sha256 cellar: :any,                 ventura:        "3690fcf6008126ae81e91fd39904eaa1b169439c44124317338aa65713fb5dd3"
    sha256 cellar: :any,                 monterey:       "fe7c63e989e3b980e835efb3dd8e0982f1e301ecdc7caabc9fab49e89a503682"
    sha256 cellar: :any,                 big_sur:        "eee59c092cb9b73f21ad996991013564014846627a26c0a9117c6f3e3e30625c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4ce61a12a6c7259b543980302a71c2a47e9eea29d22faf8cbdd53131f46395c"
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
