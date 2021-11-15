class Wasmer < Formula
  desc "🚀 The Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/2.0.0.tar.gz"
  sha256 "f0d86dcd98882a7459f10e58671acf233b7d00f50dffe32f5770ab3bf850a9a6"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5b76fec36c982efda40c1fe32298efcc3f773a0407dcfc5df8cfef52ff77b16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9634700f38301f64d011c3d82b007c125eb485405eb82a4e104dae24ae42a19b"
    sha256 cellar: :any_skip_relocation, monterey:       "eeaa02d54747124c57919aaaeb2ddbfdaa89ec6866df252861d27f9bd67abb25"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3cafc7fdb29abaab57fcb77b56eb4440886d8494a35afa96fe28bcea6f68cce"
    sha256 cellar: :any_skip_relocation, catalina:       "8fe7313e596a0dde1b09e478e1135077028304a65a3acd9c862c45f9cb22f251"
    sha256 cellar: :any_skip_relocation, mojave:         "472c4c0f35344b0104656ae6f2af41991d4cff8793d1f38b7e6bb597429332c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e203711d9f105e62878a0e9dc1a828335c8b03c99e1546763efe28272cf728d"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "wabt" => :build

  def install
    chdir "lib/cli" do
      system "cargo", "install", "--features", "cranelift", *std_cargo_args
    end
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmer run #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end
