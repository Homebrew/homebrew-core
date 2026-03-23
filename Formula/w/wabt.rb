class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt/releases/download/1.0.40/wabt-1.0.40.tar.xz"
  sha256 "e152b0c348825923df10dc39ca248609dca67ef52c7a1575f3ac61a808603073"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2825e7369c2068e1ba6ed713e8064919482347a8a535565c17c578bc40ca8efc"
    sha256 cellar: :any,                 arm64_sequoia: "9af547598b1c2d76933c4b20c935cb038acb90791310364bdfb7a0264e04e123"
    sha256 cellar: :any,                 arm64_sonoma:  "f2a1e485280ae59fc66a565dbe7af005cf272447bdb3a0398c8653a78a1a5658"
    sha256 cellar: :any,                 sonoma:        "e9f2c887130dd4c7f1aeea5f1a49b38e2f382fd8aaed77f230314db2e2831de3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2330042a1c61ef857c5202e82fa61d9e9afd217a8df3011cdb6637f3a4a370e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12237fca24f1c1aace64b7e6cc5122710a07c9a88d3e911624e1ec9148d6c33d"
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
