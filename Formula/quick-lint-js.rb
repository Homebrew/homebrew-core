class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/2.11.0/source/quick-lint-js-2.11.0.tar.gz"
  sha256 "6d3d580783b219d8ff4f7883f149a1f9b47dba0fa4a40e172a7215c918f67a49"
  license "GPL-3.0-or-later"
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ddb906981ec7d1078c2ee9897b6d1d8fd9286576ee918ac7d3fca53fa5ad658c"
    sha256 cellar: :any,                 arm64_monterey: "d0dd6276f2882bb2e652988fdc15d6ea9820809710ffd73a9d8ddbe613829717"
    sha256 cellar: :any,                 arm64_big_sur:  "eefa91188a135f9d3342cb7d68a0341ec36942369cbde1df85316018f78fc38f"
    sha256 cellar: :any,                 ventura:        "798117f3af42acc8479efe2baf9b7a28c76058a7612cb2fe210e2d9812abf174"
    sha256 cellar: :any,                 monterey:       "0f0ec361b2f1dceb4c2bf32b8dc16b0789239567e7d6b585a2dbb267a83ff4ab"
    sha256 cellar: :any,                 big_sur:        "30fd611076954c5f5c7dd1bdbcfe4a5361ad47714a3feb826f591d283c703e8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65a074287b7899e23cc86ea22820960017f3c6e3c56b8dee123e70ec753dd37e"
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
