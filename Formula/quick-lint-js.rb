class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/2.8.0/source/quick-lint-js-2.8.0.tar.gz"
  sha256 "e432e0635f5acf1b0fc1047b2f7f21ad78ac545e29403cfc38ae0a88abd37b41"
  license "GPL-3.0-or-later"
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0d06a3c1d2959cf9cf41373e257736de49510ccbe86e753c1608556f53e499ba"
    sha256 cellar: :any,                 arm64_big_sur:  "779ed9441b636e0d19a889f91f72e2345504546246f15f0681beba7c8613c576"
    sha256 cellar: :any,                 monterey:       "91a25e747d1e6cdf8a5e5692673cf544422857e52e14007b1f1d2cbd3783cb04"
    sha256 cellar: :any,                 big_sur:        "3a2ae7bc93ce26e587bc6472be32ecbf4a17895f9079da8bf3a9803b9956ed5a"
    sha256 cellar: :any,                 catalina:       "674ed5b441c3d93cb046e7ee2c8f198ad9358b2b98acc1901d9010993f5318aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3531fea949f7b4d111f281e3c13e2516264c95d5ad90618eb851b76f0011b60"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "simdjson"

  on_linux do
    # Use Homebrew's C++ compiler in case the host's C++
    # compiler is too old.
    depends_on "gcc"
  end

  # quick-lint-js requires some C++17 features, thus
  # requires GCC 8 or newer.
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"

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
    chdir "build" do
      system "ctest", "-V"
    end
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
