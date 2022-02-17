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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ddff7f8d977d0f3b80853d46ec4429c5addde05077234737b204d8e02b8bd84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3beb4f82b667b6b2210e3e077b8ace61d75cad18f205db79e936ac905736bf8"
    sha256 cellar: :any_skip_relocation, monterey:       "9bf660b5619c87efaaf3b44cb62c0b345a561e60e6675496e112a2573e1d0d02"
    sha256 cellar: :any_skip_relocation, big_sur:        "da864d370bdb3de3878007c7e003b90666698b7676ab0bf246523c0f0021a6cf"
    sha256 cellar: :any_skip_relocation, catalina:       "9d34e64abf6a46d9cb00c9327f8c95dae92226698e73d660ad3d96cd684fe1e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5b5993fa6cb0e649de405c34fdf439502dc348d3dc54a026e158b43e4579ecd"
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
