class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
      tag:      "1.0.34",
      revision: "46e554971eb593f9a071b8d9acd8229027b1c374"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "faa22a39441bb893fb98b32da3f7536a4cb077023939d7a053caaa2f0faced34"
    sha256 cellar: :any,                 arm64_ventura:  "18654972e19a5a3ac6505e1433a0c2132d293600bcec00d83dcee037b47a5d67"
    sha256 cellar: :any,                 arm64_monterey: "e2bd5d6e8db478db0b64a112440ed29d644f906e1b12777844dd0bebad6bfcb2"
    sha256 cellar: :any,                 sonoma:         "04e05978ef89af86e94ec9b4e1229291f75e4ba2a32f5fa0bb10d2d15584ced5"
    sha256 cellar: :any,                 ventura:        "d1c4a18839dd492a7c1033f423a6bf1418a1e5512234ef30b20dc885061cd072"
    sha256 cellar: :any,                 monterey:       "7eb68e859161c15a9fa818078b355901d977a76ac39bad8ca1a8cc5be9ae5e8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "860c2f917d9ca19df555542833bac2519b3c71e4c6c9ba6bd6896a66e1c373f3"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "python" => :build

  fails_with gcc: "5" # C++17

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_TESTS=OFF", "-DWITH_WASI=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"sample.wast").write("(module (memory 1) (func))")
    system "#{bin}/wat2wasm", testpath/"sample.wast"
  end
end
