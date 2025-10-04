class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/3.2.0/source/quick-lint-js-3.2.0.tar.gz"
  sha256 "f17b39726622637946136076c406e89d3a98ae363d5e3c2a93ab1139bf0e828d"
  license "GPL-3.0-or-later"
  revision 7
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5c0cc46b2f1e38ae76d75b54f04ce6cea102cf6bf154f7de3a99598895af17b2"
    sha256 cellar: :any,                 arm64_sequoia: "2cf903a723cf33df215b7b98889f773d9bf7b1471bd9abf4490faf4e10a044cf"
    sha256 cellar: :any,                 arm64_sonoma:  "3d183bf0095fd0abb371fdf5f03387baa64a4eaf8d9538a5a405b0bd6c41e729"
    sha256 cellar: :any,                 sonoma:        "9a2890d6931285343405178eb2d2d938cbe7219311f991f5ec03121bf4d48fd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92d781a046c71e5f697fe3aa0694c457b82003d02cd5af5707271e45885cbe34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d31fd97aa6c9d4539b6102e7bb0667937525d5c9e0a759b7c1b05e219569768d"
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
