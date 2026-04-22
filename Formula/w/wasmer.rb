class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer.git",
    tag:      "v7.1.0",
    revision: "7a01a2680beba20eb2e719732973ed49a3763636"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7448b61cd72d3982351d36bb511ef5faa9c8534addc6f09ccee15f0fa4820502"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3840fca3ecfce9f5ca3b44545547447deae1bb8615592ad8e1c76c2a695d9cb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52158a8b0febc9f09cc81a9d0545ec600d938ae1599b99254335cddb2d357f5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b430acb5ef9f87b9712ece4fd903305ce7c27c4fe6e728ccbf04c8f2cf11d52b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e7bb3f5d6de27ac7e83a3c1c2c864d13e8420ece00da547978ebdd0737e852e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3915150f773d17ab813b713ce177b6047cc1a94eaea101d6eeb950b2ce58bc1e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "wabt" => :build

  on_linux do
    depends_on "libxkbcommon"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "lib/cli", features: "cranelift")

    generate_completions_from_executable(bin/"wasmer", "gen-completions")
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmer run #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end
