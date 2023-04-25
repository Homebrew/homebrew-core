class Wasmer < Formula
  desc "🚀 The Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "fe4258f4456c2b5743cfddfa9f9743c2c0982f21637ac204ef62e0223f2f4c2a"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca452f2fb245058db28d9c235f81a225cfe73c63ff993073ea05876f13fcccb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7347b3b47ee3c7996db603ee0139ca979150ba24d91b32e82bfe2e6130496c76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38d6bd0d6bbf6c0ee0ffcdaf622861b7c993de05369fd8c6b5a463caf71308d1"
    sha256 cellar: :any_skip_relocation, ventura:        "fa0525f65041a9f22cae22ab5ce4aa9b43bf1980420c10c06836df8c401f3724"
    sha256 cellar: :any_skip_relocation, monterey:       "1a7a37995c91628caeee09449eadb1655651c3b0a7faca28bfaf422eb3315d49"
    sha256 cellar: :any_skip_relocation, big_sur:        "05252a9af3a7313bf1e3e28938bd280b3320ce93023ebeaf4a46a1e0e41a3845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e00bcf4239c0d986156bc3120e286f855ba095782d4b383c03dcae0016de6b37"
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
