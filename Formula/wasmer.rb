class Wasmer < Formula
  desc "🚀 The Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "a04a8b32890523e39b6fa3df170248db437a3067382847b8a2e5626bc6425fac"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08419138b2a2e331104cc9b6e53db4353079a3fbe281f8189fbef6bae5318983"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcc3e7601327fff26605a11d2815615123cad9686b36ba038bf2cc4ce8e423fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fab4a78cabf623d8529854f63cef5d98ec0c06355aaaf6f32c7098df827b2f1c"
    sha256 cellar: :any_skip_relocation, monterey:       "20b42e2d970f384ad57ec865707a7c9b6dd693a77bd4b6297c17fc6a1fa87585"
    sha256 cellar: :any_skip_relocation, big_sur:        "370b77ea4b534dcaa3263fce912e856d36c14919500e09c94d8fa05fc93054b9"
    sha256 cellar: :any_skip_relocation, catalina:       "3e803ae7c2e254c861b6bbbbe28ab2d55ddc3aaeeac8048e4dbb3713b3a8d0b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc96a3f190b6d0b482ca50f0aec60bf51c001d653a0c8ff86a38004a79217096"
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
