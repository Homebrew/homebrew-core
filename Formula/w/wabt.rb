class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt/releases/download/1.0.42/wabt-1.0.42.tar.xz"
  sha256 "a76cda3c174a43097863a07fc0b0c202f770f53e21806ea2636f167d1ffb1e30"
  license "Apache-2.0"
  revision 1
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4c2876aaf9add1bc6463c8640b38f96b898a37fe791be8d345b38121bdf63f58"
    sha256 cellar: :any, arm64_tahoe:       "fb7ff2dcb629614985f5039c63b3f8fb998d3e30d95018c7d2001ec20dee2886"
    sha256 cellar: :any, arm64_sequoia:     "1575999319eecc660b7fcfbe5bb19f0a0262a0e52de14b152a8d331f6ef84eae"
    sha256 cellar: :any, arm64_linux:       "9a1cf1a40ba898a3194449342464121d76c071804fa397313f78479a7ec44e48"
    sha256 cellar: :any, x86_64_linux:      "9dd576f532afe4a9b5fb606592ed11163d0bb9117274c7f7eb555053d5840cb6"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

  uses_from_macos "python" => :build

  deny_network_access!

  def install
    args = %w[
      -DBUILD_TESTS=OFF
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
