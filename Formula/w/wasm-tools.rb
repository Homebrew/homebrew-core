class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.247.0.tar.gz"
  sha256 "664741d72b9ca45ba34ccc46b0747cb4900200be4ddac028d23f679c8ee557c4"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43ecabea1c7599e5a3573c45f30c00c197a88b1954e9cd9b56f06dec626a7eac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fac9752d384f09d65d969e3e937ded39e8784055eaa572ae33ed4b92068f707"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d30a745a07aaad9172274448c276b8bdb12004c777ce8f865fa3ae20eca0bdc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ba185177cb116905800f2a81b3cb3fbb2d04ecdd5bdf543d7805c7d16688630"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a0e800ef209b375a6621ff24b7451941290bf8f88de0f21b62704fffe028af6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60db181ec2f490ab421108e366e13e4c9d3ce00685f8f2598bbfb9d838a28c3b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"wasm-tools", "completion", shells: [:bash, :fish, :pwsh, :zsh])
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
