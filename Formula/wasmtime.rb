class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v1.0.1",
      revision: "c63087ff668fbdffe326c7b48401acbbf0e82a65"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d1e4eb1ad46c9f3e6e296f28d3e57fdac4ac0d77081eb7dcf12593d77a8190e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc2d56bff5909f50107f996b75ad9908869a05e2f08a11c45fdbfa847faf8ebe"
    sha256 cellar: :any_skip_relocation, monterey:       "ce22576bd76c7971819bbc9a68d5228373594eecf631a2fd3dc8dd07803b2fcc"
    sha256 cellar: :any_skip_relocation, big_sur:        "eba4c5ceadc99388434ca692e72a6c79e3f8d4dfec0d8191dc2f34854e74b8a8"
    sha256 cellar: :any_skip_relocation, catalina:       "1ef5bd1765d5ff600f8093d407bbd3094da1a2397b2e279412f3d41f713333e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e641ab487d233a8fa8422ab4803a87948f9c1772c903a01712ecb1fce9b4522d"
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
