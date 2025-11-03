class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/3.2.0/source/quick-lint-js-3.2.0.tar.gz"
  sha256 "f17b39726622637946136076c406e89d3a98ae363d5e3c2a93ab1139bf0e828d"
  license "GPL-3.0-or-later"
  revision 9
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8405596a26fab46448ed23dfe7e1cd0d7f52366a01c89cee1f659f33c397e256"
    sha256 cellar: :any,                 arm64_sequoia: "a6d85402d81e565f90d075d3df4916a1812c9c20337ef6b4d6837dbd58061417"
    sha256 cellar: :any,                 arm64_sonoma:  "4f864ac4249fb6361884f5a04be0fcc0d3a573312d57a173c8f13af901db1024"
    sha256 cellar: :any,                 sonoma:        "f43c7614519f0605ea64b7bb2efc4abaf020877e30233bd9900564e60438da78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f897fdc0b75af9220d94d92ef3313a2fb4a747832f6ab5216a302aeab0c100ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64a3b1929003bccc8cad2ad431e77ecec7f0143a9d7637977c46fc0dcef59b40"
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
