class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
      tag:      "1.0.24",
      revision: "21279a861fa3dbac9af9d2bab16c741df17a86af"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af45c48d712f5295d9b2fb8e2f4e5ebc749ea75a6b2a210a563f12d7e58ee2e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c627a735cc9adddc85410079cf7cc878d80e15b7cb4e71d35b839e102060a62"
    sha256 cellar: :any_skip_relocation, monterey:       "57184078c1183acc2b718fd21de56f78e652484f77eb630d4c522e5e36706ac5"
    sha256 cellar: :any_skip_relocation, big_sur:        "5063bf505cb9066fdcc4ed20ef27bb15830d0e7f78647d6eda9676115df191b5"
    sha256 cellar: :any_skip_relocation, catalina:       "89b6ffe009276c61cb439b1882104d547b0dcc6630c7724563dff4cd724119dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e1d109a96ebc103e82b5bfada7f39c9df0a15e59af96cec693b05a174fac8da"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

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
