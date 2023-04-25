class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/2.13.0/source/quick-lint-js-2.13.0.tar.gz"
  sha256 "ee262f6a6bc45e869393f4bfb7e0410fadb7a73d68e64c96ac984e3433c0800b"
  license "GPL-3.0-or-later"
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4e64fa48368c02605fe2b58c6e3d4fee1c57dd0f4ff5e584a28d51dcb2a5c3bd"
    sha256 cellar: :any,                 arm64_monterey: "e5acd4a77b3db8c854ca6644f938c513d8c04b9c92322dd6b761abeec76cfca2"
    sha256 cellar: :any,                 arm64_big_sur:  "bcedb003eb72951f23df8397be413de4f8d761162ae8a1e10959f9a95609ab0f"
    sha256 cellar: :any,                 ventura:        "1b07a52564bec228d2ccc6cdfeeccb187f6a0fc0c891c4bcfd0a57d8a21cf6ae"
    sha256 cellar: :any,                 monterey:       "bb1228cabad810257b05a8aee64d481bb9522ade52e9fa50e23139a24dfffb27"
    sha256 cellar: :any,                 big_sur:        "44a1d3abd86303d45cc018aa46acd64fa15c65e6c484ed21ce3217086582c232"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "222f25821240cc21a6d7412566c31dc07cdc7893b504e2b510f020d4a77fb0f7"
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
