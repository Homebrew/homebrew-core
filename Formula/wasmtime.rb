class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v0.31.0",
      revision: "c1a6a0523dbc59d176f708ea3d04e6edb48480ec"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91c38fedbb76a6da652b2391ac39000adb737748449256285a4c0968d4010307"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b42520963e80a43cc17873ae46ef8af5be2dbc28a7bb1a8cc7c77116766f1660"
    sha256 cellar: :any_skip_relocation, monterey:       "7dcc00b6016419a4a5a37c689dd91f6048d36427b6098d0be868e4c691ad6827"
    sha256 cellar: :any_skip_relocation, big_sur:        "60be05185d5ea54b069521c048adf88a77ba1c82b6f036f8343e7997e9d30c67"
    sha256 cellar: :any_skip_relocation, catalina:       "8ee7860663c850031cc6d5f83e6fb691c79684f7a0cd753b262bf8c8793ce9b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fbb5dce887f3c6f930de15171c99ba1961484a77e4edefcc9457d9b98005528"
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
