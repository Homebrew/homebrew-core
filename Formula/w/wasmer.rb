class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/refs/tags/v7.0.0.tar.gz"
  sha256 "e522bfd979ad1892e23823e665f285b5ffb90bce585848617f7e2dd03e7c56c0"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2853202ea049c14c7766c03e087cd5a3c514b7e7ce6b9c17e2f53326c1d68252"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a025248f43ae83434e817ed0efc9ba621da46610ae6f48cd0f51f0dd9470b29b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8be56c1a61cb599a1282f1f46683cd1bdc21dd6cbdbaf40bc7d2a07174744240"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8b730c8ee3c3ac6c4452e6a36a4cfa892f616805667c00c3c3efa16e896c0ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff998b030206db7b563a936e541b424fd8b34ed5d8fdacb3425faff9d2e154d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b89e172b84d76bfb22657c5538721165d72f805ef1ea4aae67742333fbc1505"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "wabt" => :build

  on_linux do
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
