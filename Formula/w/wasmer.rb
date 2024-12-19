class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/refs/tags/v5.0.4.tar.gz"
  sha256 "e6f0df11dd4647fa3d9177ed298a6e3afd2b5be6ea4494c00c2074c90681ad27"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89f25d4cb160f60a678467186f8f3fa976e719a5fe8f182fbf6b2a5378913b7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb97327d68246373e10b5a0ece1b66cac378792dbbf6e3b14ebf711bf7bbba6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3341355501e7df25fd235ff3cc2a3252289d633392d6c56a9bfedb382e80d0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "da5932717fcdee30e592d4c14f2ce65006d79b589e45eab05ff49e53dd6de68a"
    sha256 cellar: :any_skip_relocation, ventura:       "7d993db18105f30d565f03711fa36f82acfa24ee49a270f616f850ce9b09b65c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab947b74b03cba811ca9125af5ee6826904cef1507d138b18c8acfa3112cddd8"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "wabt" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "libxkbcommon"
  end

  def install
    system "cargo", "install", "--features", "cranelift", *std_cargo_args(path: "lib/cli")

    generate_completions_from_executable(bin/"wasmer", "gen-completions")
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmer run #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end
