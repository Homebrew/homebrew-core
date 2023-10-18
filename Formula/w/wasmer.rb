class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/refs/tags/v4.2.2.tar.gz"
  sha256 "8ca4cf3afb1baa9a56d7d63ef01b5d3e4e4a9b2c67360285f1c53e7eb3ac7be1"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6f3c0794734a59a53ecf0bf340836a3dfb4b8f9c410f55e1981c48186184e79"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af75cefe3603af013998871f3b8cc7a3ca81caa30dea85ac4e6b0aeeee8cc95b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ec9b35048be1347ad273e17ace363a2ddcf1fd49deb0478070baec3b0dfaea9"
    sha256 cellar: :any_skip_relocation, sonoma:         "66f840031953fae1658e35666c97c18159c85852ab5e7a9604c4747903c9091e"
    sha256 cellar: :any_skip_relocation, ventura:        "092f5470d7e4c71a6b17439ed3f451963aafa17400ccf592ba51263d7a49e649"
    sha256 cellar: :any_skip_relocation, monterey:       "fd1fa29a446b1ca47d2e21458e756c9584c3f6ad53032e457f483cde3fb66f1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17aa90e5042be3743108668bcfd95647f5cd9872826e28d972a06c64ef4642d1"
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
