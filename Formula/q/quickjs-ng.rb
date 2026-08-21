class QuickjsNg < Formula
  desc "QuickJS, the Next Generation: a mighty JavaScript engine"
  homepage "https://quickjs-ng.github.io/quickjs/"
  url "https://github.com/quickjs-ng/quickjs/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "97c80625b26775a4c7ca618c004d4ea24cf99cbf867e4eba78bd927a8b23d106"
  license "MIT"
  head "https://github.com/quickjs-ng/quickjs.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "327df6140b60c1d789a19cd54cbca7b312d848c8a49cae6811da3871fd4bd36c"
    sha256 cellar: :any, arm64_sequoia: "1680ff159fe8cd1bf165d9c9e14e4b18016b22d86ad80e1e141b27486d14fbc9"
    sha256 cellar: :any, arm64_sonoma:  "620c075bd10521dce17054de8c0ece535bc6fcebefff80b24cb9ec0cd8fd7be1"
    sha256 cellar: :any, sonoma:        "c2f6908934519b040c6858ff60bef626e6536897667c0c17fceb3ab92a182065"
    sha256 cellar: :any, arm64_linux:   "4a304e2998f8821529bb935c573c70f48be8d0f6783d26989d8788d7f09cde03"
    sha256 cellar: :any, x86_64_linux:  "6b64f396cf94c0b8bb6f5cb38b2c491303e1b4c64a29a6679ddd33f523420486"
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
