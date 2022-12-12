class Wasmer < Formula
  desc "🚀 The Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "d3a27e5fd834573a226374e0c5ed8891af9fab41749efa2aecbd3d22c3f950a2"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1b6e729d809eb85a8c22a56eb46c43c9c715e610413ce7fae0a771eba5559bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b07745a6e10bf065644f85472fc9c70266de94f102d503dfcdfbf9525bf68a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b2cb17959c9ae8b8793c3a103ea6a19a06077e96bfb66e90850170cbb92afdc"
    sha256 cellar: :any_skip_relocation, ventura:        "92463d9ffcd179376cc4dda522e3e2cb4635498b8ebe44fff4859f493515f626"
    sha256 cellar: :any_skip_relocation, monterey:       "467b08831da6b30bb8a03a78521c06b7ceb6046da04b3481fdd35d00a16b4e2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e824d6ce85c008580959caa1e76679b58602658b84a52d9384b3d120e6c4816"
    sha256 cellar: :any_skip_relocation, catalina:       "0d45a7864398ceda12d108c90fae226ada24fb2e6bf670d29aaee84fae0c6714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcaf58194df6c5dfca73617af0a4cffca1f8c3ad9f9a8b4bd6ce170515f5eac0"
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
