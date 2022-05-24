class Wasmer < Formula
  desc "🚀 The Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/2.2.1.tar.gz"
  sha256 "e9da2d07c5336266f8a13332628610b3833b9d9d45001b1b0558d3b8b0262e4f"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfcb96ce1f32091ce15f68763ed6fb1c2b6a274030618e6ff63725516b128a2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e8321de908d57a6012450235f154ba6d9cfa9a68e1ee0c66fa3c126190abf39"
    sha256 cellar: :any_skip_relocation, monterey:       "03b7f8ebc3cdf6495bb8d603ed338ed42d2cbba80c4ed5323711e1d09f3d431b"
    sha256 cellar: :any_skip_relocation, big_sur:        "bcbe55a5ddc2fe15b1b9a533ad1faba4af6fec0e4c7eb1fe6146928340767268"
    sha256 cellar: :any_skip_relocation, catalina:       "08b296f5c3645d3f3f0584a674689efa99b05202026edf158feba549de9244d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80831b9e1c6020111f30790973e1a4a3cd034a18c75ddd3e3da617bb9ea83f24"
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
