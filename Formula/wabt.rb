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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8dcefbff4b9770d496d8771b2294763a7686c425ed85da1e69cc778deeacdc85"
    sha256 cellar: :any_skip_relocation, big_sur:       "558e3533b83784044c443aaab28cbbd83b6bce18ef34e7c54898b33e96b56e8b"
    sha256 cellar: :any_skip_relocation, catalina:      "c66077777e94c758da994582e4b6ee260a5a5e0641554efaf9b62e6791cf1398"
    sha256 cellar: :any_skip_relocation, mojave:        "c9cd360e6896f9eb340874dd0deea7e99c72a8352c2e66bb2aa334690bed870b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed9575f487b8f84e50a6833683c9943ea78d25f25821d33f1cdc413c2cca7ad0"
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
