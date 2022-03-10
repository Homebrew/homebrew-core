class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v0.35.1",
      revision: "5b09b74f4c5e0fd817febd3263947ee3682759bd"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11ead3dd358bb4954c82e1ebef59bf8562c7e63aa65c798bf7f61461c336dea5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec3abbaebe108a17f9e8a15376295083170159c66e4277b07ce2684bbcce7aec"
    sha256 cellar: :any_skip_relocation, monterey:       "39f215ebd601fbbb4af27dd1da660f9331587f154cb1279103af9f7f20e23158"
    sha256 cellar: :any_skip_relocation, big_sur:        "89509935fd9c36fa168797eba08731d52846ec6a612d7b52e14963b7d0184baf"
    sha256 cellar: :any_skip_relocation, catalina:       "f63ee2c693766fda802f4f6bff7c7463212215402b12f425ad067b0575637069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c243a49c3c8447aedf3e86783ba3da20a8ec47af9ce45360fc3455cbbe5afd8"
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
