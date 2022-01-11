class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v0.33.0",
      revision: "8043c1f919a77905255eded33e4e51a6fbfd1de1"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb1a07662a357bcc0972a1633fe258ae5e76e95d4ec81c230dfdf2dd8e1325aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64ca6da7af11531cc22514f3bfe5e994761822965d1dbb8c253cdc9f96c8b046"
    sha256 cellar: :any_skip_relocation, monterey:       "67e56f6eb1620c9fa1bb4ac19052ebed1e3dec89fdd8f3b5b1abdd565b77495a"
    sha256 cellar: :any_skip_relocation, big_sur:        "875c86cc0e44084c1910e97ee7032ac7a7d6b0d8ede56a1b62d04349a8b234dd"
    sha256 cellar: :any_skip_relocation, catalina:       "26333710730e3d428a2fd44fb0714aac9bb30f844cb410605a32ee722c2bc6f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5b36609e633e843ea32203144a33946dfed6774f92d569a0e26fbc69f2ccbc2"
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
