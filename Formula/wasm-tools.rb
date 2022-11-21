class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.15.tar.gz"
  sha256 "f8f418712bc2ce4b2dd07a605335bb7eb2d9aea862203d476999de6f8e0b5ab7"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f43375d1b2012ef9af9255c23142b8524d2f29103a234f1ab559ad4d7861522"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90d8b3477e15cd483764321c1c6b1aca8a131ed35d471ef89c213dc256558d9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0216810dc22174b7b7d3a23c3a6292699ac849550989497869b8935fe70fdc7c"
    sha256 cellar: :any_skip_relocation, monterey:       "ac235b2dda78c82873bf95dd44cdfa5b2d14c934229b615bd33029028711d263"
    sha256 cellar: :any_skip_relocation, big_sur:        "02466ecf69d7a8ae86b90c71f56fd52cc31786491039973d3683fabe1d443331"
    sha256 cellar: :any_skip_relocation, catalina:       "60c065fcc2494282347d6f0e51fb058b2b15eaa07fcda4afa8eb0a23adba7fba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "937496a77c0bcbbeb8dca57da62ac1245a6d0f8221a3363b761f99f6bd0d0570"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    system bin/"wasm-tools", "validate", testpath/"sum.wasm"

    expected = <<~EOS.strip
      (module
        (type (;0;) (func (param i32 i32) (result i32)))
        (func (;0;) (type 0) (param i32 i32) (result i32)
          local.get 0
          local.get 1
          i32.add
        )
        (export "sum" (func 0))
      )
    EOS
    assert_equal expected, shell_output("#{bin}/wasm-tools print #{testpath}/sum.wasm")
  end
end
