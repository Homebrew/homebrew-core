class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/refs/tags/v4.2.7.tar.gz"
  sha256 "c4a4c0249b048b846293a79009b59183f2da4abedf14e88e5a9f8d1a689a84d8"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb78abe96d070131f5a89696b93c3a1b200e12503f2f57f16b18ee6909b88bdd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea79cb15d9b76bb6b336fde3518ada89f3d0aad28936b5a610bcd388230a6a9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ffe014c438b29e864aa512dd203057f9db08472d715dcad21f179d5ed51bb8f"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ed3088349673e6f112e2238d1ea67fb1c03cb9eb02cefb786805b4b295b30f2"
    sha256 cellar: :any_skip_relocation, ventura:        "52a60028706dcd1b25a5733e1d96bd450f1255749485fcdefd8e22c16548e13c"
    sha256 cellar: :any_skip_relocation, monterey:       "216f4733f6e5812825545eed8830f85ecf291fad569b4589c2930b553832282f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01d3b181b62d684b496744fce7b9fd4d33ab2253e1a266387c83e579b8c47101"
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
