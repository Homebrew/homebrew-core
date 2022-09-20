class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v1.0.0",
      revision: "9db8498faecf32dfc5c3fa923ac09250656d8f04"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5645e3f32f3235dd16a914e1d7505a651487c2eeae8e5081396e199b6d83ee5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c2b6bc57dc7ca3049a2b6e98e1c64007af1542bad7ff0e64d72f58bf712c77b"
    sha256 cellar: :any_skip_relocation, monterey:       "2b1fb6795c58b470dbbb11b1c677570e319683e14ee642f68fc35a4da352fd61"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1ba75a0ff65b79081be94e167e5594ac095766c3f193bfd15f86f2a2f5b3a35"
    sha256 cellar: :any_skip_relocation, catalina:       "dbe2672fd23dadc080e779aca464931f51aece48ca28e18b2fe12d4c73ee4256"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c828fa110018f819b4c5ac0d1f7d632b45b4bb7f80577ff726729944d3e4055"
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
