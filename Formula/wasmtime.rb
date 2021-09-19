class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v0.30.0",
      revision: "572fbc8c54b5a9519154c57e28b86cfaaba57bbb"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1e54231a80dcdd8a3ef12d4e23472cd18e609c6c758bc74868ca027cc9a4de50"
    sha256 cellar: :any_skip_relocation, big_sur:       "696828c1a710e24d80fbb3d611299fe4b72c51a7c897879967e3d8d8acf9af65"
    sha256 cellar: :any_skip_relocation, catalina:      "462ff64295b8d8287fef10079b38ba14e1884c2e75ef9151d4f7a09077a8b109"
    sha256 cellar: :any_skip_relocation, mojave:        "af8587541c55c3b06e28dcb727f06364139b39b1b1580ac37f1bc4ab686093c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cd563ee6bac25f91d109bc7813cdda266ba8ef958a910ab281d7057b094895b"
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
