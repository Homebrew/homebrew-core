class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v0.29.0",
      revision: "81f1dc944fc0f82db7e930ce47b4d1433786481f"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "136433d0ec5369a6685d9933c3302a74836b3fecb69dcaf66bda9622bb42172d"
    sha256 cellar: :any_skip_relocation, big_sur:       "31f0a85a18b265a95a88cef8bb953ba3b5f2793a73cdae86e84cb09362710c5b"
    sha256 cellar: :any_skip_relocation, catalina:      "741e62eb7b97c4a9e6d0e55b7476966db477782bebb7c3856dfddf447fbd8cde"
    sha256 cellar: :any_skip_relocation, mojave:        "991ea5ad43a53a43d1b5caabfacdea18ec9396affa167f499fdd3867079e3c0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "778fe87d3a058b63089762d2fcef5749a8ccc611b7ca402b384a75d7d0b7513f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmtime #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end
