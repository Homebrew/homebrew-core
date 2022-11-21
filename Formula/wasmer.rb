class Wasmer < Formula
  desc "🚀 The Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "c43ea154af906ebd1747b52f36c8131bfba41c01809a2042e7099f1f1f5655f1"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e2d77d83f2ea5d83040e9e5b2f0245ca0f42703d709acfde1757001aa6ded0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31c3fdab10b937746966b283705f12ed4ce3e15beefb0d06659280a9e69f2565"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc4ff8499e6c13acdc6704da734bef1bbc5ba8871abf145a3c05c51b0f3a0458"
    sha256 cellar: :any_skip_relocation, monterey:       "204b6b9fa0e1140b3d60d6db435f846151aee849be6fda834b19a3832c072680"
    sha256 cellar: :any_skip_relocation, big_sur:        "026f6404cdc5a10805a79477e3f2e96c778cff623f47740c0dd6c2e4d1b16071"
    sha256 cellar: :any_skip_relocation, catalina:       "e594210ad4a047d4d7be94ea18b2ab383d2e4ae796c8488b01af18817041ac47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d82806d76b0c92b422a980c72e2fefd6ba87474617c2ac32e4306576ae2515ee"
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
