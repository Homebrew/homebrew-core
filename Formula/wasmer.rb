class Wasmer < Formula
  desc "🚀 The Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/2.2.0.tar.gz"
  sha256 "86d742a59025c4fe49838e8fb98aec754315cb9e0710c1b793e16f8caa566cfb"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d206fbda506e4b5cf65e6ce467997edeba077476f7c936781e4b7ebc2c0cdea6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "936d62ed63c3f11aed9c5800c9025ce864ece877f10343c9352466adab50d295"
    sha256 cellar: :any_skip_relocation, monterey:       "ec343ba3e7540b5a5532c4eb7b33f35ac386d0b8ce3053f660ba12d638066f38"
    sha256 cellar: :any_skip_relocation, big_sur:        "913c506c06b934608c0fbceb635681f5f3dc06e047d7bf923ed4843070e5e3b7"
    sha256 cellar: :any_skip_relocation, catalina:       "90341fad160e2fbfd7e54ca70370abd0b88aba55a9fb64d8d86a3853bc05679d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdc91059ffa62e54a6c0d2354a0afb1033e82cb0276f296fd5f7f38c87c0381a"
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
