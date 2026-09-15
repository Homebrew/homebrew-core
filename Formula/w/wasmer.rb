class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer.git",
    tag:      "v7.4.2",
    revision: "f154bd28c5ca6a9182f7dfbb1a0afb26d8c63637"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cd0589a1f5c63552af2aa556214d22ba95f477e6e8ca225eacbfde296ca053f3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "645354455aa19e124791140925fca91a2691af9784aed25112f56dadc1cace2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7e174427c0f90f0290229b9ac0b1276664eeb129d3287bf241b4456e5a00b718"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "e6da3ca0204e83d5154f43b63513de9de4cb3a9f4ca346c8592de4b7f2128fd6"
    sha256 cellar: :any,                 arm64_linux:       "936334d6813998f21d00c4a63e9909d59847acf6a0114d55e883b5b5fa957bd4"
    sha256 cellar: :any,                 x86_64_linux:      "dcf6513e8178891d44afbc21b7cc5aedf53392f1611f422e5219e45347605720"
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
