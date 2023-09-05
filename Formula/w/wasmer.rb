class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/refs/tags/v4.1.2.tar.gz"
  sha256 "feef6d11ff387ba672f10db8db232bc4068b66c5d96b0aacb698a2e0fb317287"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c2e60bae95ea3a76a3cb5588c19755675b93fffccf77179e68a4d3c03886f8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4767d10414b4a663ca6033b793151c87fc42e913a713e69f6709b6b230d15f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c24e068704d0381b9dc4b5da14f1ab362c230e5299d89ee5e313a23ac1290931"
    sha256 cellar: :any_skip_relocation, ventura:        "a4c945fe4a0f32acc122a25d768f6baf4b876420e966d2f71b60a8842eb84623"
    sha256 cellar: :any_skip_relocation, monterey:       "4171e7b9f821fd846240830b1208d3b6a0c40d9070aa8f358a04ddfaab066158"
    sha256 cellar: :any_skip_relocation, big_sur:        "cea2846c77c6c033bdb21875588d5c8a974f1d4647f69724a7d5fae80b5d311f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1797a412addb22db2e4fb4f86aee7f6f6c5bcd0a56a9bc7d3ed98004b29cea72"
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
