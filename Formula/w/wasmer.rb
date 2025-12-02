class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/refs/tags/v6.1.0.tar.gz"
  sha256 "7bccb5b86724ea35ca9373fb81092080a615c1baa6129a8eeee9ed3e3f74b9b1"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "834c65f05099fcf4e9b897cf65c0fa095e0109ef4f67b33f5fcd17447d06f24d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b91d9d0d03bbc7ff78747b82f6f996486d895024556fff2099136ca14390dec5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a853a4998fd7d3e45628f3e64d35cc1229131f6523167bcf87ebc1e892e41274"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c331e3bf88d7d716b539bcf1c8138a811012409800d1e32a30f905a76e575f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9a70e8e4b18be1a2a740f6f640cb0bf416ad7083d49acb0bcb799b31d08233d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f7d7cc3e60c85166620e66d9a172dcce02a0f3115dfb64cadac458cddd85fe1"
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
