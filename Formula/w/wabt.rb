class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
      tag:      "1.0.39",
      revision: "ad75c5edcdff96d73c245b57fbc07607aaca9f95"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0291da71b80bccf8fdef8e90dba77ed9b9224b979600be3b147991283d07a1de"
    sha256 cellar: :any,                 arm64_sequoia: "64fa9dd1fdd02791106add72ebd733a5ffe62168403a0de3782085226969352f"
    sha256 cellar: :any,                 arm64_sonoma:  "8a4313e460970d5917b1620ac72d5fdf8ebe46a10468c2341e15d0321315bc31"
    sha256 cellar: :any,                 sonoma:        "eff82080d216c36405ed575b7ba8f117b5ea0c2c5a54069d66e421e2f39b3c94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3762402996fb5c1148b09f78bf9cae956fe1b1c411f0523a3d7bc8e8be6dd395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0c0ca08d5ccfce51995c961ef4680d568ca98950adac3bb5af13724baf8afb6"
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
