class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/3.2.0/source/quick-lint-js-3.2.0.tar.gz"
  sha256 "f17b39726622637946136076c406e89d3a98ae363d5e3c2a93ab1139bf0e828d"
  license "GPL-3.0-or-later"
  revision 12
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1d8abd1efbf3b612f762dd7a9c8f1b4c8cfb5b0540cb80702df22deccbf22686"
    sha256 cellar: :any,                 arm64_sequoia: "cf53bcaae51537c3ec29e74e1ca8febb506c7ce3abace2c8bc71d79d16c32ba2"
    sha256 cellar: :any,                 arm64_sonoma:  "3af1fd83465bcaaceb6549b6446d98f6e010a582dc71722eba853a818803bc08"
    sha256 cellar: :any,                 sonoma:        "65e5cd9ae5a96af133efec956be0935ed231da0cadeca2d7af18875850b68764"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c93598fba05a4402479254731c4879cea0d74ded7d889ea395d102e1d56c06cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0a8d29f50545ba7a100653acf8b9afa9195f8ef498a5f055c6a4a2471635347"
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
