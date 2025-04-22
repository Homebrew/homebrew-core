class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
      tag:      "1.0.37",
      revision: "5e81f6aeddf94fd7743c8c2049f5084c74ff6ab1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6ffe898ee2dc9eb43b14e61f74eaf8510d899d47c9ee5e8ce76ee52cc298bfa8"
    sha256 cellar: :any,                 arm64_sonoma:  "1fc9959612c3241b4a801f890b3b6be565da13c49b3982f7cbb28ccf407ef7ea"
    sha256 cellar: :any,                 arm64_ventura: "e1e1cba32b34354946cd8c9e7e2253e2a4307b025ace9e1f8c50c2ee3eb1e16a"
    sha256 cellar: :any,                 sonoma:        "ff46dc276f1f820803a8a57e4d17ce7ac8823b9b30458b2d3f0becfe24f4c17b"
    sha256 cellar: :any,                 ventura:       "09d6ad8f29884e7a4d4851cee0785a966d522b97ce781f74d37b4ae54c0ad8e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d0bbcaa4302807b8ea7497e153268045f02814266954f008d6248564f4de58b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9362ed0da8bc2db2e3b2d5febbd66fc61fb81f017568fb2b13b5d305aeea689"
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
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
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
