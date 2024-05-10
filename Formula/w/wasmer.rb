class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "f975b852e0774d8c5ea0a184c6a39836a37dbf669c417a4c5ed2775805b505d7"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53c270eab0b06cd9241f6cee1d03e0220b750d84e7845263768b80d601f898ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "340823b4582d3eed9a37fad2f7deae4f349aa77a99b9890d581f4969e86dc8a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b834f7d6fc1961a32c1e10ce8918a2e5a67a7086a7ece456a757f26c492f5b78"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e036429de7761cbd9b4f28f167d5fc28a468b0a154af4dcf85b21132ba9f1ef"
    sha256 cellar: :any_skip_relocation, ventura:        "c0e6582ca5f0fe764761829eb81bfd80c44b8e40655542b65ca99e036a121baf"
    sha256 cellar: :any_skip_relocation, monterey:       "2b948ffa901998398016f167420796aefa9c32966c07d8eb23f9705ffe6d972b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b637ae29287e5b7a2d2010024291ac9b1b07abf4b71787a063f11b42a37d238"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "wabt" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libxkbcommon"
  end

  def install
    system "cargo", "install", "--features", "cranelift", *std_cargo_args(path: "lib/cli")
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmer run #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end
