class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "release-3.0.0",
      revision: "01815a711ca88f38b2e10eddac949d0eaa15d90e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a9faaa009a327908b736390102a6360a04affa83e29438ff2ea8f84ef6171a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb21911ec62eb9e6f4a067a3c07a7648595a5c0b2af164ce06a8edf45daedae6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1008456c0b08066e6f068fb6c7d73ceff0e0e97d1596d41df569e9d0ab86a2db"
    sha256 cellar: :any_skip_relocation, ventura:        "18c139cfa5fbde76b37d353e8128bcd108e7852e5aee6e484d4551868054612c"
    sha256 cellar: :any_skip_relocation, monterey:       "acd5b208aea8caa2aec58574c80d395ca78245a2da128d034f621230fd8be0d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4b05875c9d97a3576e661f1c4a267e8ff6ca696e65f2e73fe013daed95c888a"
    sha256 cellar: :any_skip_relocation, catalina:       "3d6ffd69e0826cd4d7884922ec0d7ac3389acb8b6de99bf0f486989331db1a83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7f20d061e8f5daa74c9ffd54087e6e4f358a5aaf6050fc5b13d084dabf68842"
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
