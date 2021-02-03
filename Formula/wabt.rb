class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
      tag:      "1.0.20",
      revision: "830d32a41449278cacb0bf17530618d47c43340b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f83360b912798f372cb57827a7b5cc89063f9d79c4eabf845429ccbf49c37e63"
    sha256 cellar: :any_skip_relocation, big_sur:       "06bedfd798d896d5530c8801f830b1ace48bcce10ff438a393e2e01d4b8d1a7c"
    sha256 cellar: :any_skip_relocation, catalina:      "910d30dea89023dadf308768eee1f8d186e88ff50210a5603c392e3dc33546b7"
    sha256 cellar: :any_skip_relocation, mojave:        "e9eba56a16e053365d515a6637a1b12217cf65c2c3f81988a0d80af8fc2f0094"
    sha256 cellar: :any_skip_relocation, high_sierra:   "77e89094c8a0d95abeb513f6ff3bbfcecab82ed4cc740b7be1445cee79eef6a0"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_TESTS=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"sample.wast").write("(module (memory 1) (func))")
    system "#{bin}/wat2wasm", testpath/"sample.wast"
  end
end
