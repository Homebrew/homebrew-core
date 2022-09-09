class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
      tag:      "1.0.29",
      revision: "c32fa597218dbe2c25b43a9837a8475b493ddb71"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02e681e9b25d6171252c035319de538781d0fdf597556314d945ffe946d6a21e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e69c6b33949769cbcc9af2ea6e7d9bb63329d93c354d1d0d6577d223981c36e4"
    sha256 cellar: :any_skip_relocation, monterey:       "b12757b5ae82647afa2a2642eea763616bdf2f75b2ac2558e7c3eb8514502ce9"
    sha256 cellar: :any_skip_relocation, big_sur:        "63d035b7f213271905159ef1244a6d771b3b7ae856bc34c610da8a9406f85c06"
    sha256 cellar: :any_skip_relocation, catalina:       "9916c18c358a468f9364742cf4727b426caa1f0c183e55b384292853cd24f7c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47407a00ee59170838d074e8a4882f60b2307dbd8bfcb4a30334ef1c00925337"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  fails_with gcc: "5" # C++17

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_TESTS=OFF", "-DWITH_WASI=ON", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"sample.wast").write("(module (memory 1) (func))")
    system "#{bin}/wat2wasm", testpath/"sample.wast"
  end
end
