class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
      tag:      "1.0.32",
      revision: "e5b042a72e6b6395e1d77901e7a413d6af87ae67"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1eb5c405ce9ce146c14d92cd28346d1dc96f50628c5465b262e2ce196b7ee7d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d950aecc90cfb408b96b0e26d948d210f37555a65247e83392864c6f50f371d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca2169fd646d31cc5d83627047322f24d0ca7ec822c722b01131ad43bf6a8254"
    sha256 cellar: :any_skip_relocation, ventura:        "8764f33058349f6c7932b7a4e3a081f582dee2c8b8538467d1df8a441a9305ea"
    sha256 cellar: :any_skip_relocation, monterey:       "c9c9ed4d30a4784b8f9372763fbd3854e4470a1df7d72275ded6889e0c8f5b3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a622dc5125000135392cce649bec1f6534a852a232b413bfc52f4470887b408"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a029ae780d4ae86f54fe39d0d52545d9b4f285409d8eaffc18abb66cec196944"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

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
