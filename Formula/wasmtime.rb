class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v0.29.0",
      revision: "81f1dc944fc0f82db7e930ce47b4d1433786481f"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c0237be2d4ac8ea029abc6a91366e66088021572e9ee481df992429d64097911"
    sha256 cellar: :any_skip_relocation, big_sur:       "922204dde4ced817ea6b7af645d328f503d90e6fb234280493b246228f4e518b"
    sha256 cellar: :any_skip_relocation, catalina:      "fa1144a5e08ef1a65da8dfb0aeb6bc938c1a4a7aa3d227c352a2b1c695ed5185"
    sha256 cellar: :any_skip_relocation, mojave:        "0212e601e7a82b96e3b8843fddfc027951e487e1cd2a97df8eb6ccc6f4bb469a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "183ff366ccbe15ee1f71731f6e3f2289fa10473cb7582b4e76f491b9119462ca"
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
