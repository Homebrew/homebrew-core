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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ed9228130cae7caaf99878bbb659c2ffd6004b2ce8fb1d93105aa0e0f993c4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35c8a5d9cbe6e488251dcb3dd8c0d129230585b4e3911ec0b0621d31257109d1"
    sha256 cellar: :any_skip_relocation, monterey:       "9c56b047954e585faa6f5870104f4ced672c4d5f87b3fc38463cdca98ccc714b"
    sha256 cellar: :any_skip_relocation, big_sur:        "373276a1f3bb3cf8569facf06baece468478d3eaab13f92d0d780c5215044b2b"
    sha256 cellar: :any_skip_relocation, catalina:       "6d1178fb069d4e7a109ae7a5105d8290a1e753670bcb2b205815abf113043e88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cfeafe8d40277ebc638324223ea361dd4e1711dcba42006b9483dcb74b7456d"
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
