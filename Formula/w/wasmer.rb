class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer.git",
    tag:      "v7.5.0",
    revision: "82ff099e082da586b38af79986abbb8b677f8baf"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8d1867c9c1f0e48c21de11d758636b45cf6e83bc9b51ff5054b3fe320d9eed8d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6ee4ad5bf6368e2c8d7b4477447be3710e7c64f840f33ae5b5001464b52474bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d1753a7b257a88f08391dc99cdb16d91a97ffd815f79744acfdf231f8735c981"
    sha256 cellar: :any,                 arm64_linux:       "9f8d63ab2f048f22e8274458b175658ca76235637a4ead60f7b5c3876438e178"
    sha256 cellar: :any,                 x86_64_linux:      "571cb00d74f5849e50123c920426c86733334df7b2d0d9acfc95d9ff02205fed"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "wabt" => :build

  on_linux do
    depends_on "libxkbcommon"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "lib/cli", features: "cranelift")

    generate_completions_from_executable(bin/"wasmer", "gen-completions")
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmer run #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end
