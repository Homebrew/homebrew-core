class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v2.0.1",
      revision: "516b9592d7d9a73977d05f193adf0bd7ca25a919"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2e8cb3f23cc55835e59259a5b6dac2a8f83a4e8b709d47018b368ea9df6cf8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91f5c7373070a8961eeb5beda43149e16b4854de00f85fa7174733175516fd52"
    sha256 cellar: :any_skip_relocation, monterey:       "2f572727d251743960d3e06ab3fd18558fb261b6b27f053d38ffe14ee50c8b58"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1c9edda71b12c5ab97665a3788e7886284c7b4126539ca8185906aecd98c81a"
    sha256 cellar: :any_skip_relocation, catalina:       "20b4c8a510b81264226dcd65c0304ff7cc30e98704b012fbf0f3ae573fc0656c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fe17191787d168a21353686eaf6183782004b5234bb67185c2dcd4ba88f7b77"
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
