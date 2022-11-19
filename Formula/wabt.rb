class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
      tag:      "1.0.31",
      revision: "366a86a119727bdc957c2bf988ebd835c3ddb256"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be7e92f7458baf55703b6e9119b6ba05af5772c9f3c01df05cb2a9ce858e0778"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b16aaac9b9f2eac3faf76ebd8c3bf06914a1ca8d86944c847cd37c92b0e9f38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c1c6e67b081a542434492b20ad4fca8008f4bf6983cb795ecb68d7c174563cf"
    sha256 cellar: :any_skip_relocation, ventura:        "3766150ab2fa1770568f6dc3e3ce308b2a23dac037cc448a2204cd5ab909e4cc"
    sha256 cellar: :any_skip_relocation, monterey:       "fde02c2a3a1fce77bb1b31607d6d511db904795c8d42abe66be909a174686c4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "be27de60808339887261a566771ef518af3f214809383e2664db06f145d483aa"
    sha256 cellar: :any_skip_relocation, catalina:       "5b81a1ef75253368faf9ecd9107aca46387f8d8158acae795941aa716eaaa70e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cc4758452fc3f94d38d05d11f5e44fd89d17dc011063f263d4e0fcfa17abb54"
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
