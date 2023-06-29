class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "fcac7573c6c54e8bed8e2ec9dc3d3973ce1fa949c6c1956b3b6bf7e27bb186bb"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9876205874db521ce6988b49f3be272e76f645ecec779aab4f37b0adc847d472"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a80c548ebe4e8416ea39cb4d4e3a4c5f76fb63614402e40f880335cbba7e2a9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "465a5006b6c3d1d2620a586db150ea7d0516132333530fd1f62e7bd86b85e018"
    sha256 cellar: :any_skip_relocation, ventura:        "e61cb967793dcd1156b82f5f5d3207d989b59b176250daa0688ac1ad6e18aa6a"
    sha256 cellar: :any_skip_relocation, monterey:       "dea34e0c1f52d04f76d90f7270b1b5b946c9766df2216d15cb42518439685a89"
    sha256 cellar: :any_skip_relocation, big_sur:        "1024a6f2ca0eeeab7f47692221ba3e4ae9c51eaae8450ce12058243d06558304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a17d1544c046d0692d0b8e83d164023dfa6dedcddb46b609a3cd774ac3f5c14"
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
