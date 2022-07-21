class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v0.39.1",
      revision: "19b5436ac346b8e61230baeaf18e802db6f0b858"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91519e60bfe22c7874ed2abc36e88b27c8a716d990c505f884a2598a0a9ef685"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f693b5d107dcf0f4218ac6b2565e7a20fc7787c09d0ff17bd7d73b752fecb3b5"
    sha256 cellar: :any_skip_relocation, monterey:       "e47d126e01fe35d91fa2d907de42770bdad28dc4987b7423f13115e38c3dc645"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b9f05307e4961b5508693518452ef68a3d0b0b59d9a48ec3e9cf4d3af274459"
    sha256 cellar: :any_skip_relocation, catalina:       "8e1c0bab7cd362b48e70b328daf1440684439104edaf88a730834982b8fcb4b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06ab2f76254f0c066e17be96f143b45f366762cb824754c39af414a41451c5e8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmtime #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end
