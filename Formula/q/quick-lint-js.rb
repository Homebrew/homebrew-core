class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/3.1.0/source/quick-lint-js-3.1.0.tar.gz"
  sha256 "d5f133780ebf8735e4f6e4c8fafbf04dd7a7db17cd2c31e899613d5bd32d0b1a"
  license "GPL-3.0-or-later"
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ccbc910977ce2bae90989492b97e39881404540ee23e45f96a608bd0fc597a11"
    sha256 cellar: :any,                 arm64_ventura:  "576f96ccaf4de545bd5107125972b7aa17ed2026ead83185eb61015e3745f15c"
    sha256 cellar: :any,                 arm64_monterey: "0043be2efd94cd4afa2920dffcec9b664350e97e4fb40edaffdd9008b899697d"
    sha256 cellar: :any,                 sonoma:         "eeecacade785900a97f78e2e84a44263568bf8ea8a3984843775f5e99f5b80e9"
    sha256 cellar: :any,                 ventura:        "7545841196ee029d0a6da1027deee4cafcec58d6544381d196e8d529a204a62a"
    sha256 cellar: :any,                 monterey:       "45d0da4b37c388b28f546e2a34a5fd10f7c47d3cff54661c624e036bd56c4fe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d5884c88227ca7920e25a1ffef8dad2a4ef6396cbcacdb5d1ee85e17c2c2a3a"
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
