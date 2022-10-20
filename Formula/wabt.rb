class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
      tag:      "1.0.30",
      revision: "8e237a2c5214f887bacd95b887a4ea055e7f6b89"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31bc86948a7785b27832148d2fb46e76af62853dc55c03e119517f73335cfa6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d02f34c7a5218b39f73b087fd6d010c9af483c86773671b2edee590d72f7eed6"
    sha256 cellar: :any_skip_relocation, monterey:       "ec14e79b46ba16c83847e035cfc0bf95a9139d087ea986eff44056daf234b523"
    sha256 cellar: :any_skip_relocation, big_sur:        "258de9ad9dfb11e871f68a5dbe563ac49594653f5beb114d5e2bf5b48c55a182"
    sha256 cellar: :any_skip_relocation, catalina:       "7dd5359079d92af76aa83135849938023053250ab783212495beda78096708fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64a7381298d48d9af56b67dbef46fc028a2c6a41d934ab658bf8bdbda4c12a1d"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  fails_with gcc: "5" # C++17

  def install
    # PR ref, https://github.com/WebAssembly/wabt/pull/2017
    mv "include/wabt/interp/wasi_api.def", "src/interp/wasi_api.def"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_TESTS=OFF", "-DWITH_WASI=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"sample.wast").write("(module (memory 1) (func))")
    system "#{bin}/wat2wasm", testpath/"sample.wast"
  end
end
