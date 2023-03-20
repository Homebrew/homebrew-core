class Wasmer < Formula
  desc "🚀 The Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "84b4dce118f7903412672069b52c4046cbbda136889d2d2f7d2bbaa52c91f90d"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8014dec59b468b3277f7e3c3e8021e2d37b5f24f605a608f16ecc5f4d8a45073"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fc38f83809150efdda1de7f2b2423d5d72908ec138338b18f730067cf214451"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf4824a938c7fff9cfe950815ba58fa34e00d8874f1d811b24b05e8b702c2ab9"
    sha256 cellar: :any_skip_relocation, ventura:        "dc0359d8e8c0ed116dc27a31299bb945df4d8808d74e246af84d66a5ed840a84"
    sha256 cellar: :any_skip_relocation, monterey:       "cc9926ff308006cb6635f7833e21f81a64c9c8e8c386b6193e95557a3303cdbd"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb4c9d3732920af1db5bed201a0421126d2f4cb01ebea299f1b0958cc9558d90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dc3be9feb01902a85a6e5f63da001cc41c64452039bc5327699926ec0d849f3"
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
