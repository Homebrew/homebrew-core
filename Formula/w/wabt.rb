class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
      tag:      "1.0.35",
      revision: "39f85a791cbbad91a253a851841a29777efdc2cd"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e93a3ac53a941ef3f0654e9a39146d787ead32c1157f622eaae98fdae04c2a07"
    sha256 cellar: :any,                 arm64_ventura:  "f07e944cef422e656955a100d50aadc44d4d7f9a28dbf5fdd51194e5dbe84580"
    sha256 cellar: :any,                 arm64_monterey: "0596df9c5331bfb59d40b02b252944eee49fed3066700301752aedcefaf9c1de"
    sha256 cellar: :any,                 sonoma:         "6139b239dd0bb94afe1118adb1dee2f73656a0ebbe35ecc7c6a6f0cc29851b4e"
    sha256 cellar: :any,                 ventura:        "9212ec614b7f01c029b22a667b696b62f1bead2d8b0456956548ef5bd1373216"
    sha256 cellar: :any,                 monterey:       "a5396f14eea8d8803dc28a01e52e107cab7ccc08dafda6cd8469f658c1d14d21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70a958486332cd5fc7a50f17a96b0e004e8197be9e812afe3854b6ac68c23fdc"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "python" => :build

  fails_with gcc: "5" # C++17

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_TESTS=OFF",
                    "-WITH_WASI=ON",
                    *std_cmake_args,
                    "-DFETCHCONTENT_FULLY_DISCONNECTED=OFF" # FIXME: Find a way to build without this.
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"sample.wast").write("(module (memory 1) (func))")
    system "#{bin}/wat2wasm", testpath/"sample.wast"
  end
end
