class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt/releases/download/1.0.42/wabt-1.0.42.tar.xz"
  sha256 "a76cda3c174a43097863a07fc0b0c202f770f53e21806ea2636f167d1ffb1e30"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8d9d4301d6367d0885568925ed4bde689f7388ef5039be5cd8fff6b9f88befea"
    sha256 cellar: :any, arm64_tahoe:       "f633e46e0c43fd94d24cfd1c377ffde30bb6960dde7da0f7d0f94c1a4b8be04e"
    sha256 cellar: :any, arm64_sequoia:     "6c753b42e46037fde432e38d610e0f182db239fe8eeaccffd1ce7bedec18c34c"
    sha256 cellar: :any, arm64_linux:       "e734461106d03b4ffc228dd1c99dba2cad92029d11e95ac2b9bb510bb95cb169"
    sha256 cellar: :any, x86_64_linux:      "87f9681fce361b612caa9dee882136d59ec16a145c11836d2b3e7708a251baab"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "python" => :build

  def install
    args = %w[
      -DBUILD_TESTS=OFF
      -DWITH_WASI=ON
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]
    args << "-DCMAKE_POSITION_INDEPENDENT_CODE=ON" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"sample.wast").write("(module (memory 1) (func))")
    system bin/"wat2wasm", testpath/"sample.wast"
  end
end
