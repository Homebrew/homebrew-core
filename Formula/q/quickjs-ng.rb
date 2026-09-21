class QuickjsNg < Formula
  desc "QuickJS, the Next Generation: a mighty JavaScript engine"
  homepage "https://quickjs-ng.github.io/quickjs/"
  url "https://github.com/quickjs-ng/quickjs/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "559bc4c420475e55c7ab4510adbc562f55d7524d75e8e89d79ce4bb02f5687d9"
  license "MIT"
  head "https://github.com/quickjs-ng/quickjs.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d16d3608d538b1b61f2fbc062a117d88dfb1f2857b99b43867bfd064d57ddebc"
    sha256 cellar: :any, arm64_tahoe:       "87f8466998b94688d6991b40c1682f9dc44d1c83ea8d6fecee2e15eb00288983"
    sha256 cellar: :any, arm64_sequoia:     "3b7ee057b20abf6a32ce66387946cb95037446c820032e9d9e2b7088f28e87a8"
    sha256 cellar: :any, arm64_linux:       "ad399022c60c13a8b1bea2c72ef6dcacf6de9c46ce0b0d420fdabc621e39cf84"
    sha256 cellar: :any, x86_64_linux:      "a8882caaf9b102caeccfa98a4cdbcb549ffad6fc41cefdf1fc6a247f26cb424d"
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
