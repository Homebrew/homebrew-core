class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/refs/tags/v4.2.8.tar.gz"
  sha256 "4c48828f6f8167c2d838abaa38b5124b32174bb4ee5e14d59599b1b7d4e32189"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b845451355cc0f66b826df7ff83e6f23e9a6457e8f554abcc00e6052d2e92346"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c76cbe7d66fa0c4208436b276e56c2a1860078cf5740f3180608b6452ed28658"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c969ff1df202e85821b604f2c034ed509df625208a7ceb7ad8afbde4a38adfe"
    sha256 cellar: :any_skip_relocation, sonoma:         "3739afc0edf7a6d3211d0750b84de119f9535e8e3b2067747bb0be34e17d3c0b"
    sha256 cellar: :any_skip_relocation, ventura:        "0571bfaf3706485e365d514a05bdac661cf39d328f181387dfc4a6fc6ecde417"
    sha256 cellar: :any_skip_relocation, monterey:       "e48125ce2eac771d38336bee1e7365647d1ca87351030c9069334b230199a56b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d29219fc67504f1f59c9e5b9f135b807b2f372641b8d4e274c0f04ce0b956be9"
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
