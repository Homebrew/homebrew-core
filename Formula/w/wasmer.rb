class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/refs/tags/v5.0.4.tar.gz"
  sha256 "e6f0df11dd4647fa3d9177ed298a6e3afd2b5be6ea4494c00c2074c90681ad27"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "125ceff044fe590c81adf25dd1cd04d472b5649e8e54cbe122bca65579e9bbee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7323f35dd94c282210b5ea295257a7b6c1fc318f0dafd6ae4dea582b2ed8f62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6bf51106be2fdb78fd06b11268fd10269c3dfe1c7fc1c67c84f84b195e3f7ead"
    sha256 cellar: :any_skip_relocation, sonoma:        "502738bb88139da09da3a9065cd1a2077abc8d2a538a6a023f0072882a5fd0fb"
    sha256 cellar: :any_skip_relocation, ventura:       "59019f8fd8d6e571cf0b2db906d773ca12904213150222508767c2ac554c646d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54117ff9c51b46fe47f105210ff3a372ea637c003fda56a9b2ea747f66f285fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10eb158e7950f7de195258ec2a41abc6d2f8dce12c0bd1050917328adb34623e"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "wabt" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "libxkbcommon"
  end

  def install
    system "cargo", "install", "--features", "cranelift", *std_cargo_args(path: "lib/cli")

    generate_completions_from_executable(bin/"wasmer", "gen-completions")
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmer run #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end
