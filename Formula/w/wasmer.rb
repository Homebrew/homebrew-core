class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "84dd57c798bd8041a1adb1aa65aacccdb11687b64f0e134ef7a5b61fa44ab2f3"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5897de9624cc797efd31a045228fcdf13be9e45d8f7400b47e895d1a743a1734"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "106595154a015b42484e853b3d431a21677ce3d9404356e4515cccb1bbc77633"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0bcd0efcae63597b4ab1188c104d06b24f92a71737dfce5740a1a261886c0b92"
    sha256 cellar: :any_skip_relocation, ventura:        "5ed0825498d7d453fd94c9a66d9f65be080c4dd078d6cac9c2849c5e9157107e"
    sha256 cellar: :any_skip_relocation, monterey:       "3db92083022c23a3f3ffd25f0f5274c593387c8c8c96b5e4de584a0ca4c3f55f"
    sha256 cellar: :any_skip_relocation, big_sur:        "39cb9d42167005134a51027ff3e2eb29fce00b1c375007f5c655fb758290e36e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe641ef73cb8f98251f93ba59e9c4b05a0c29191ecd51951649c1fa60059b51a"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "wabt" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libxkbcommon"
  end

  def install
    system "cargo", "install", "--features", "cranelift", *std_cargo_args(path: "lib/cli")
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmer run #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end
