class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v9.0.4",
      revision: "6842d0dc7c9084faaa35f64e205237fa7c2c8933"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33c75d2febb9a56ce03c13ab368ecfcea55c20b8420625f83f88cbd1d4f7c67c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2212e996d14a351a9fa598610ed8b423ff7b8f7b6c43cae8b3220bea2ee218f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28f871de3434e281c551eb39d69208d96e86e3446ed7d2430cd2f32d57dff141"
    sha256 cellar: :any_skip_relocation, ventura:        "59770a48d3ea0ad59ca4cb84634d38eb4cc527ca861ef0e902c5a1d9504c07bd"
    sha256 cellar: :any_skip_relocation, monterey:       "79ca61cedad82c24e5eeed7e27013001d8cda210b2686f27c18b733574792afd"
    sha256 cellar: :any_skip_relocation, big_sur:        "b39d1e141bb28dd1a6a055a2b4a3e70a7d548f87936fbaa420e4075583d4a646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbe8ca73eb939324db9eab95a314f1fbf3e9742892cb144f65cb1be25cc3bca9"
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
