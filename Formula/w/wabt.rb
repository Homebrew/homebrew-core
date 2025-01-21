class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
      tag:      "1.0.36",
      revision: "3e826ecde1adfba5f88d10d361131405637e65a3"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9c8c3383a667f9930bf6b7e92a5ecfada06d52dc973aaebfe74fad1c9cf413e9"
    sha256 cellar: :any,                 arm64_sonoma:  "6623b6eda3ef06355df0aa5826f0048ed47363608df17fe4ce04b083723ba68a"
    sha256 cellar: :any,                 arm64_ventura: "cacc4321f1793cf3de5ce0cd5c7e815bb304b9d685a5be0b42d08d8cb08d2969"
    sha256 cellar: :any,                 sonoma:        "0177a246fb21ff547aa0df436f337ab1923e3d7e87ff521e8a9e27b2df9b66b4"
    sha256 cellar: :any,                 ventura:       "a3a3ba1408a348483f6b710080ad55eb0a02d367fde5a457bb9164683472b21e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9db533eaf5d9e50fc16896ae6525eda7a3a0b0bbc512578b652d1ff0a79bde2e"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "python" => :build

  def install
    ENV.append_to_cflags "-fPIC" if OS.linux?

    args = %w[
      -DBUILD_TESTS=OFF
      -DWITH_WASI=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=OFF
    ]

    system "cmake", *args, *std_cmake_args

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"sample.wast").write("(module (memory 1) (func))")
    system bin/"wat2wasm", testpath/"sample.wast"
  end
end
