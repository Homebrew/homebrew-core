class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt/releases/download/1.0.41/wabt-1.0.41.tar.xz"
  sha256 "ca9e69cc1de13b4633a3c74fd697319303b21108529d4f10960af4e1f4a65893"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0c69784b6323ff4755c133fd21ef1c12f5ff2b389ddd55a163b4d46b84a74383"
    sha256 cellar: :any,                 arm64_sequoia: "c0f0934c0ddbfca8923ed441c247426c43e532f0eada6c9fd80e89777e791428"
    sha256 cellar: :any,                 arm64_sonoma:  "334b2517199cccd2d03e032c743c6221660ef3454b2926596f5a386fbebc2bce"
    sha256 cellar: :any,                 sonoma:        "3e1fb5039b55bf2ec19fb20ef2d47ddca69429b4af37c1fc8405b4e1385fa24a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7b2fea8041ace07a06069f591441f64776acb549eecfe793ae75c14355866b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2c1427ad7640607e8c7805656f7f8ab5f2ff32c0449a9025c0b590782deb69b"
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
