class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v8.0.0",
      revision: "7c84feba6d504a6e79355cc85491418e8c07f0ce"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2dd28c911a41e2302edd9c3747e02ff00cfd04743cafbb030095c85ec43c9f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5c901e6f68a3fa81f71995a3b5d138c2739dcf0e5841f1552201ab098ef4b4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34e24df03a444508b822eef944ed3e87e12e52f7449e2fb1f51ab8a2a1c1f8fd"
    sha256 cellar: :any_skip_relocation, ventura:        "11bec0275307e4d8c26348ee08b7ea1a1605a8b26017324fa3a0acfb86d0fbee"
    sha256 cellar: :any_skip_relocation, monterey:       "91d98aa95e80c73d5e80573b81500c9ac21dd3d66685e7cb61e65b963661fd44"
    sha256 cellar: :any_skip_relocation, big_sur:        "f95d97a0d15e67416bc9c68ee21481ad978f871cc4412ed4f554a0a1f655cdd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ae287d01be107c9e6791b06673b1929063ccfc644d0a9a5e3d4b7a1cc24f73f"
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
