class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v0.35.2",
      revision: "59bfe50acaffd69f267946d35abe9f87a3b07e29"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3be81da4ce65944d99ce9f2559adc05885ef884f4be86e5ae9918b6c58670b9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "462a0817514a713282edebc3a5f963108231b843e94f0e0338d3c3e35ae7a565"
    sha256 cellar: :any_skip_relocation, monterey:       "0bba14a9f7586961f8b07f9358e66eadb4feb8c3325ed047def5d4c83050b93e"
    sha256 cellar: :any_skip_relocation, big_sur:        "abbfedd86ebda0417a80b619da066361f6edaef2f35eb08e52dc0ef208a596f5"
    sha256 cellar: :any_skip_relocation, catalina:       "73d4a6255f29d440c8a5b69c7c7e940a2686fb5a98662a8154ae0b9b68818489"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba53f02942f8143118bc6670aa9329410a56cd5da0a6fb31545edbf9aff8d3b6"
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
