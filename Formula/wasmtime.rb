class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v10.0.1",
      revision: "a45abadbc39a57dd3e404231e2751a80cdafa4b0"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbc3ed84d13baedc0e562ef10705283867b6d132fdc71456e24a480688b0f8a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbc9a29cff2fcaae84bb8f5f6b08f308a7c210dcb4328feda06d793bf09c159f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ca86ca59e45aadf89eb0eb427cf5975c1223ee36d672694ae0894554c472603"
    sha256 cellar: :any_skip_relocation, ventura:        "a1d599a18f94d124d9a38a0874a3211404c2c4ed2dc1a97322d9757034e3d8d8"
    sha256 cellar: :any_skip_relocation, monterey:       "7324dcdec3096cc0cfb62868708a09b0086e371939062d9b080ebcbb9ee3d4a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa230751d6ae068f29027511ee69931662af39ffbfda7ef0c05ef2c098d57c5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ec764a843731fc1c70add5ff98d4448fe63c5e43cbfe34f44fba1bdf8a20d12"
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
