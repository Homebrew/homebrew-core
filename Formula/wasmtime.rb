class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v0.35.0",
      revision: "9137b4a50e2e883ac23049f6abf3381155620189"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28468355cbc6df6a088843589b55b31cf91b5ab2f5582d93a6093e12c9e2f384"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9ec5013b23a8d1a15c244c754af82ed15511e484d83772b732c846162ce66fc"
    sha256 cellar: :any_skip_relocation, monterey:       "32c4ac2f9e67c630b742f88d03d8296a164a4412402917a67a068ac51242feec"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a7b57822d0badb97eb114cecfe367a44cac7cf7703cd8a3f68d431b06432553"
    sha256 cellar: :any_skip_relocation, catalina:       "65a265c6e515f09b2663d92cfccf5839a22fccfa1ec6e2d8c1d3804960ab3600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d6f2046b84063faf324b311c0c340b15b1ba0e1a4f36bd7126b020c177c09e5"
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
