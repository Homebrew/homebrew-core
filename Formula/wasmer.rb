class Wasmer < Formula
  desc "🚀 The Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/2.3.0.tar.gz"
  sha256 "b27d12494191a5fe4a77b2cce085b6005f2bf6285ede6c86601a3062c6135782"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "514ea51087a5ef409726ede823433d520e1d00b145480bbc7ee1ef88ae771cea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2d043dabcdb1f083047afc9dd1c2fba60db860fc6d1dbc24825baee457ba68f"
    sha256 cellar: :any_skip_relocation, monterey:       "0f70d1097ad9c3d4190825845eca0273887f6378e7553b6ec93eec4a345d7f8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c066197bb6e8fd6ee49195d534d2584d774173dcdbc2a818b792d894edfe0ba9"
    sha256 cellar: :any_skip_relocation, catalina:       "eee9f24bedebff4531ff92b1235be06a315fd7762d2b45f841d38ab383f11d7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17fbc61a9c5699fad9c4c3ae2bcd51b01f3e3f30e9cc733ad51ed73ecb018e02"
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
