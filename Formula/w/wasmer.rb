class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/refs/tags/v4.3.2.tar.gz"
  sha256 "7842ee0d9253c12785b5f59e6fc41b42956e1c1469478d1e12960906e9e1ccca"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e139ef034dbefea7f202573c0822975d394a1da1c288d4c4afe237648cbcd066"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "727bed8c87db0fd44d07d09afa91e47562268fa7091b4b7853cae5181acec490"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e1ca4828725ac3fd8aee4b13beef4bcea1ca229d1a3294735a30b4012315bf2"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ed681ac16523bed0eebd4d3b394aadc4cc910ebd5b82a343e595c26ba4cdf5e"
    sha256 cellar: :any_skip_relocation, ventura:        "cf39251b08572f1e3e99e9119afd1af7ac1710121d234e326bdf573543c5ddeb"
    sha256 cellar: :any_skip_relocation, monterey:       "5a4ee8655f2b56f1d51e03d64b2b5fb44ef5b97ade87931aa625e4d281f5c801"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5f3265b013954bb3d3393eb2474926cd74995a1e6fe4a5d6cb895c597b76766"
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
