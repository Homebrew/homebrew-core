class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/3.2.0/source/quick-lint-js-3.2.0.tar.gz"
  sha256 "f17b39726622637946136076c406e89d3a98ae363d5e3c2a93ab1139bf0e828d"
  license "GPL-3.0-or-later"
  revision 4
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7e331b410167b9db6176ac0b4714c68155e3dc46eaac0fd84c148c3593fb43cd"
    sha256 cellar: :any,                 arm64_sonoma:  "d069b3c046bd604f695e77439a2acd42a4c54b55dcd8d9c88f727ad6e8065e4a"
    sha256 cellar: :any,                 arm64_ventura: "3b3679f107ca3e63afa0e24d8009a5afb9108fcab47a80e6c0c9e3202c63bc6d"
    sha256 cellar: :any,                 sonoma:        "45f88c80eb309f7374b5521217c8ad4f9d66047098db24d94ff642fa7817bc8b"
    sha256 cellar: :any,                 ventura:       "26320d8bf7164177d405c37aa5c90d87e77195dda60985f984c2a85e6919e1a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4feed4afd117387b35e8dd9257c848eed94153898a3463660c777cd4d917f37a"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "pkgconf" => :build
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
    assert_match "E0034", shell_output("#{bin}/quick-lint-js errors.js 2>&1", 1)

    (testpath/"no-errors.js").write 'console.log("hello, world!");'
    assert_empty shell_output("#{bin}/quick-lint-js no-errors.js")
  end
end
