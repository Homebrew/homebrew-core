class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer.git",
    tag:      "v7.4.2",
    revision: "7a48a071c7682a409d148cf37dc8da58322a123d"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "158ef9e2b8dc0b94679ddd6a52df9fcc1b9d258f2d6009ffe8bbbc3774128548"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1ec4161d5b249ae7491b2e5fdef8e35585bf057922c869120e03bb796871553b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7a076aac0bffb5bd4899c52200569197f08ae23652d78ed8bd7550454e9b062f"
    sha256 cellar: :any,                 arm64_linux:       "fcf318732f1312ed7e6002fff49cf34d10dccc8d8091dbef296c94042a6759e8"
    sha256 cellar: :any,                 x86_64_linux:      "79e8270b6a8319d23d7592fcff1948284285b9410b0484e76fb8d22fc9ff709b"
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
