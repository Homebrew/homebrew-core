class QuickjsNg < Formula
  desc "QuickJS, the Next Generation: a mighty JavaScript engine"
  homepage "https://quickjs-ng.github.io/quickjs/"
  url "https://github.com/quickjs-ng/quickjs/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "c4e813951b7c46845096a948e978c620b11ab4cf5fd622ca09c727ec31f42623"
  license "MIT"
  head "https://github.com/quickjs-ng/quickjs.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "de8a6992790d4697c0c764ee2fa0167c72bd9c507f39469ce61af784791c323f"
    sha256 cellar: :any, arm64_sequoia: "0ba4edf1667317e2e0740e3a8fc119dab2381d26a1b1e4c5126ce8280b2d3b77"
    sha256 cellar: :any, arm64_sonoma:  "dd9305c1ba1d8be559ed4d9869dab0896ba4d6c003771f8fc3f32d8da1ec0aec"
    sha256 cellar: :any, sonoma:        "18435d162177184756583b76fef2544bef06fd96721d6e25fde93b6d9da5e285"
    sha256 cellar: :any, arm64_linux:   "bd8e4df7f64ab2f550697210547a2aac95b02bcd28e1df02803cef8a7c703bd7"
    sha256 cellar: :any, x86_64_linux:  "a6f1dbc69589d405d1469dc0d19e734b942900411f3d5fa7a040cdbadecdde6b"
  end

  depends_on "cmake" => :build

  conflicts_with "quickjs", because: "both install a `qjs` binary"

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
