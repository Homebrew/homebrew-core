class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v9.0.3",
      revision: "271b605e8d3d44c5d0a39bb4e65c3efb3869ff74"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b8ffa781f193a3f3e164b313dad4b2d12dce28acd00700f5eefe740260c94e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f13e60b0e107d326d25bb823a2cb2558b6ef250bb4180137eeba9dea27db071f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d3cda181f4041a7fb81f3a7f8a4540c717b292b9f66c7462fefaf59fa657577"
    sha256 cellar: :any_skip_relocation, ventura:        "7d98ccce805764d53dde4be74c16137508e21d4af1326a805a349572cc897b96"
    sha256 cellar: :any_skip_relocation, monterey:       "d6ee3a6e99bbc61bfebb27b33107df174c17cf3e52f0a9bcfb2e2c5a8871b240"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6f87c4ec3425cea2da89382aa0374e93e476bdcd049153eb678f7063e275903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40be948e7619471d969a73e31bf13e4b84b03a2c706f3bf54f3e41fcb0388b4d"
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
