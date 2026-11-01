class QuickjsNg < Formula
  desc "QuickJS, the Next Generation: a mighty JavaScript engine"
  homepage "https://quickjs-ng.github.io/quickjs/"
  url "https://github.com/quickjs-ng/quickjs/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "28bcd89aa3683fd2a946537e5ce3f11cc46b5cbf3383c7561aaef3df5ff9f1dd"
  license "MIT"
  compatibility_version 1
  head "https://github.com/quickjs-ng/quickjs.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3548576e9dc7d1902a7eceb38e5064308e29d064f107b81440f6d1110dc58605"
    sha256 cellar: :any, arm64_tahoe:       "fd7674dfed0b220af4314c5019c6269cafb24b9a1c5e0eae564b5fefafb27737"
    sha256 cellar: :any, arm64_sequoia:     "afe831ce1bf92ee1be4e11bc028525f36f6892e0d231a67996144fda7377f8b0"
    sha256 cellar: :any, arm64_linux:       "240705ce6d46ccb28d01a1fb2daf4897ade201e229d160c1d391401fbc77cf68"
    sha256 cellar: :any, x86_64_linux:      "71d104947d327da1c9975df38b6d25bb9fa3b224669386c3294e78aa84e799aa"
  end

  depends_on "cmake" => :build

  conflicts_with "quickjs", because: "both install a `qjs` binary"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build",
      "-DBUILD_SHARED_LIBS=ON",
      "-DQJS_BUILD_LIBC=ON",
      "-DCMAKE_MACOSX_RPATH=OFF",
      *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/qjs --eval 'const js=\"JS\"; console.log(`Q${js}${(7 + 35)}`);'")
    assert_match "QJS42", output

    test_file = testpath/"test.js"
    test_file.write "console.log('hello');"
    system bin/"qjsc", test_file
    assert_path_exists testpath/"out.c"
  end
end
