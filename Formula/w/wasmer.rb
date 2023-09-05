class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "5a87a2bbf5011991d6179bf6a7f9562d90d21937d2527dcb153ab40b9929b213"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "877b5be561b4ba3cf7cc2fcf42a227ef7ccf9077af589bf8fde4320191b24fef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89efd9f6dd4075ef1ef5e280c90ebbbf784e2107c529aae6c15cc44180d601cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52a9778dd44e7435ff0969b5f7be81406b0d5c03b1115bb9cb4974abec2c5af9"
    sha256 cellar: :any_skip_relocation, ventura:        "5bc5eacd5b01846b3309793e8fb4eb36bb492cb4301964b7d992438a5254b3f8"
    sha256 cellar: :any_skip_relocation, monterey:       "221ce4d20003fa6c1b2c86b30a879f072d45ff6c49341ea59124538df1fe2e3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c32881bf124d14a5d11360c8f157b492b4a5136452a861fb74c723597dba7b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fe6765235c1cc5d65b13171f600e8be244f6b99b16db93d57e914f98333a183"
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
