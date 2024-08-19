class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/refs/tags/v4.3.5.tar.gz"
  sha256 "1663a14be85921bc587941e845ed87fa9423998d7481a3b546b77ec7851c79ce"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7236ced2c00019abf470c492700233d55f851c04d7082996eb70265fd7d006fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df94f1df91aa068600d0ecf97b6fefe5208e28caad7ecb52ae14151341ec665f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a44ffbd05fa1c4ab18d68615f8719b7d41fa515b3759388b783319bfd5caf796"
    sha256 cellar: :any_skip_relocation, sonoma:         "71cd7b530a43b38a4bc12c5152390ec60a922e0bb9b7465bd18e4f72262346a6"
    sha256 cellar: :any_skip_relocation, ventura:        "e9fe6554603e62cc1b71f96220943f4991c5b766ef1939db2e8ae639aab2e29c"
    sha256 cellar: :any_skip_relocation, monterey:       "a8efb47b2a68471b8406b8d9779fc0d0aec317c4f9d196aeef8beb9bd2e78732"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79a7443fdd5ac6cbe02423f8edf1c71cca8139cdd68d308288fba56d85a1afbe"
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
