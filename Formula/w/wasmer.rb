class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer.git",
    tag:      "v7.3.0",
    revision: "35c10644f7b0aad6fd9458624ceb8429fe7413c4"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f6ddf78ba1a7dba8530ecd4b764e18a40bf2a5e4a161213f3092ee90e0402ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9539309b3563b627981aa804ad392341dbedfcba316d5d07fcb4b310e071991"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9375eeaa65345b4abb6c7ec1193f4cdcf1c43f4c0d06bdf6f5509d482e44323"
    sha256 cellar: :any_skip_relocation, sonoma:        "594e68a3bebfe0aebb1b689f139a5578ffcf0032c0f60b824eb59430e9a18a82"
    sha256 cellar: :any,                 arm64_linux:   "4ba39d8caa8c4370dee258fcbd82b076c9103aed0a390f4fd6b070689691dec4"
    sha256 cellar: :any,                 x86_64_linux:  "2c16f7017ae6b2ba2af0aec193bbbdd795c58d85ed914f393ff52ba625709cfc"
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
