class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
      tag:      "1.0.33",
      revision: "963f973469b45969ce198e0c86d3af316790a780"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4ad7998c357d89b6deee22f2483110c77b284a5c29286abd8ae21f0a97f84be7"
    sha256 cellar: :any,                 arm64_ventura:  "420800d9acb60c8bb5a8cdeed2bd6f3f1a2e35e048dd8b2d3d09cfb097461d0d"
    sha256 cellar: :any,                 arm64_monterey: "d8c1cd106d8b9bffee03675b55702b66752cfc7d8191997e939fb682882103ff"
    sha256 cellar: :any,                 arm64_big_sur:  "7148f5d2dfa56da56a4df51843493a2a5f72b1bae748da0e5e94a8484d4c1db7"
    sha256 cellar: :any,                 sonoma:         "5ddaa2013aefcc7f9e6f507dc1972d6cce7abc819c7eccd0e35da7ebaf477ebb"
    sha256 cellar: :any,                 ventura:        "cafbe4b7f8cd4b86aaefa31ae01a3fe67d24614c7414eaf6eeb6258a784bdbf3"
    sha256 cellar: :any,                 monterey:       "9db80d4b0eb11cc665eba586100ea872a70f5773ed32554b19ebe83e35990317"
    sha256 cellar: :any,                 big_sur:        "b52a3276d284cd520b8f07d32d8de17a71650d135ccda2044a05edaa2cad9bb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5d76141576f861a87c72b94da7fc0009f67de6a9a0c4469dc985d215de8b369"
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
