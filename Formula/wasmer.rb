class Wasmer < Formula
  desc "🚀 The Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/2.2.1.tar.gz"
  sha256 "e9da2d07c5336266f8a13332628610b3833b9d9d45001b1b0558d3b8b0262e4f"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7489cd7de8731f256beb27d2f3421302b2960cd4dc20d93e17d5a54b6d585f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66887a0b474d62c5aa66c9db33413689f4abb1fe6766e4e676b4adedff9a94b0"
    sha256 cellar: :any_skip_relocation, monterey:       "e79391c9d4b2511114de37b7717279b4d285577abf8a9a2f6701fe48fd8104ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fdd20521ddcf8518e16318ba73271889ee825ad79fc4209ef29dfb459b3f87d"
    sha256 cellar: :any_skip_relocation, catalina:       "3bc9c8ba279893639627c1ee740b327bee2194430cf21b0fd307c0bea226c3a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a89cab210faca2721d4db95f849d09f8b41c5da0908385298c231b4165a546b"
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
