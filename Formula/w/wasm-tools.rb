class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.239.0.tar.gz"
  sha256 "cf885578823c6f6f619ad0cb03e9446398fbc18dc1ff65b816d3c6afac8abb3e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2ec892881a6b584556bd51a12d170fc364385895a6955e4a02c2bd38d30a767"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33f250eaa7d70cfbae5d80e7f0a544397d99e15085a6eaec211f03e569b930c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94864d9459bb6607f2aef824216040baff24fa725161ec4d89f21ffaf1480b45"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c10b05086a19abf20dcd9d498e2784483564b4a7ac5ff9d90b407d7e4d6495b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f081bec5bc68a8ab49df7e1ee6a8b8789ef834e620e8dc486a273e38746f7ba9"
    sha256 cellar: :any_skip_relocation, ventura:       "4482e623c897854ef1b37b391cbca32dc0357f855d19934cf0a9ce23a6516b74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1ba5d82e2e989a3b0e0499e926c7df2b01186e839a1fd8dd5cec55f5f232154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ec11705c8a8b132e1cfa194edfb1b4a43bd410fd5ecf8168a8d915cdb1f39f4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    system bin/"wasm-tools", "validate", testpath/"sum.wasm"

    expected = <<~EOS
      (module
        (type (;0;) (func (param i32 i32) (result i32)))
        (export "sum" (func 0))
        (func (;0;) (type 0) (param i32 i32) (result i32)
          local.get 0
          local.get 1
          i32.add
        )
      )
    EOS
    assert_equal expected, shell_output("#{bin}/wasm-tools print #{testpath}/sum.wasm")
  end
end
