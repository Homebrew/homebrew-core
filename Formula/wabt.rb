class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
      tag:      "1.0.27",
      revision: "3e8207aabe969098d2b4941142a1973008c63033"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c14f57529af68d8bd217065346a149c31f2c1ef5bbf9a4c22fab0d3774c341a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85b225650cc753c030f50a39ba9548340300eb59fcaf7e21a9a8d88e91d2a3a4"
    sha256 cellar: :any_skip_relocation, monterey:       "a01df50d45a8e8f8a323d8eee7c8c8cc887d91f055f74f791ace6adf67986e40"
    sha256 cellar: :any_skip_relocation, big_sur:        "c22417443085d43af5b779c5646ea5437ca79b125a72ed4bd8a8393ff8a7721e"
    sha256 cellar: :any_skip_relocation, catalina:       "9c1d61e314e6ce82b1b225a378829200875deae1aee457bbfe7d01db756ab670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b77a2dd99a3fa5bdcfeec5c9170ac8c28dab95a0c14835df95a7542b1eb6ce73"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  on_linux do
    depends_on "gcc"
  end

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
