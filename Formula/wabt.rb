class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
      tag:      "1.0.24",
      revision: "21279a861fa3dbac9af9d2bab16c741df17a86af"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0c3a634c829542de5a75e37a1bf6c0af5611c23c7db2fdff67405d78d1b5d3a7"
    sha256 cellar: :any_skip_relocation, big_sur:       "2fd468189b6686a97c30cb2c7936e724d49fa5a769c791087470de5ad0a4ace5"
    sha256 cellar: :any_skip_relocation, catalina:      "41c4dd8e0e66a6a9b9e61e6afe1c9c2ca59435128dc98efd4a14dca038a06716"
    sha256 cellar: :any_skip_relocation, mojave:        "d205531f9c54a60c1a92526cf931d15f0d281893546d4b3bf3bbefbdd36be470"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0f9491f2bedfe53c73cc56a3f8a5dd0f1e04fa76e713cfb9d5ab9b370d5089f"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

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
