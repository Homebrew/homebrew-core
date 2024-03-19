class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/refs/tags/v4.2.7.tar.gz"
  sha256 "c4a4c0249b048b846293a79009b59183f2da4abedf14e88e5a9f8d1a689a84d8"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c03cc0ad3ac3d30249c777910ce8de4ce8c4ff8d935a8d477e6666c4fb868703"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf0b1dbc81ea9b3706074b3b958aba9a589a06eea2230bc848112001988534c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f10b17163be3b340da59f01b59c4e92bbc77c6780b33a3ac9698a9e13e82f08f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1431cc87ff17cde155e0a943ca797fa63d64042bcfae0c055a767dea3139795"
    sha256 cellar: :any_skip_relocation, ventura:        "95ece2e9d0eaf33e3d8615de4b1c88b6c2d260699a465ff42487b92fa7b232ba"
    sha256 cellar: :any_skip_relocation, monterey:       "53c7cb47a320d2ea7b19ebf2aa4bf5f9c68ded814d575a35bff0f47def78bf8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "650e0c33754574dca68f474d9dcf7c068ff4795265fc8f6842c7f1b164880dc5"
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
