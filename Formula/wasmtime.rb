class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v2.0.0",
      revision: "ff8c568eeed3918a5d591295e9384e2b1e462aae"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4120549744141c43ad57986f49650cff071c48b4ce0d8633ccf0d3d37e4d1f0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b00139fd434b1ac645c6859f85b2ed1e33578f7fa4ba19d3f2e811b3624f9af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "740ddbd18861bfd16c481fec8dcfb72a7896c24f1840f3964c34786e77175a25"
    sha256 cellar: :any_skip_relocation, monterey:       "5839cfdbca3eb9e9b594c1430573b7e3c020ef03d84c9e91f67b1e6d31e663be"
    sha256 cellar: :any_skip_relocation, big_sur:        "87d121f526d50f8834ddada6328141d10604ff83c351ace20f0878c90a606497"
    sha256 cellar: :any_skip_relocation, catalina:       "ce85246fdb16004da8253efa2fe2cef1cc0170aed426db0715e766df7075f14f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6022fbccae2d619ee63c76dbffe73426054129c8e3385ef48dd2cd7b77ccf3e"
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
