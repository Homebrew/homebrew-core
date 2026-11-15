class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/3.2.0/source/quick-lint-js-3.2.0.tar.gz"
  sha256 "f17b39726622637946136076c406e89d3a98ae363d5e3c2a93ab1139bf0e828d"
  license "GPL-3.0-or-later"
  revision 15
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b7caa9b0ab17148fe3ff006837b2133c7849f2448bea3308f0e45c3db7c91c6d"
    sha256 cellar: :any, arm64_tahoe:       "493b8be17c53a8bce31f032104c2986b78a26db1d7429fef94f139f1727a194c"
    sha256 cellar: :any, arm64_sequoia:     "45f9b4ad4aea37a30667198864569aecb7362f93bcc3afc0b080d36cda9830cc"
    sha256 cellar: :any, arm64_linux:       "0771eaf982c12cb8e30b6b4bbbed6855289b8061c736c6e436ae3cd2f144be77"
    sha256 cellar: :any, x86_64_linux:      "4ca0f31f5239376e43f5c711b2f931fd18bd3e37c436b3d90f13763bbfd9fdb1"
  end

  deprecate! date: "2026-10-29", because: :repo_archived
  disable! date: "2027-10-29", because: :repo_archived

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "pkgconf" => :build
  depends_on "simdjson"

  fails_with :gcc do
    version "7"
    cause "requires C++17"
  end

  deny_network_access!

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
    assert_match "E0034", shell_output("#{bin}/quick-lint-js errors.js 2>&1", 1)

    (testpath/"no-errors.js").write 'console.log("hello, world!");'
    assert_empty shell_output("#{bin}/quick-lint-js no-errors.js")
  end
end
