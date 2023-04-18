class Wasmer < Formula
  desc "🚀 The Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "50bccd4e3155bee881fb165ceea82234c730a79f2345988b757596dbe20e912b"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a800df5b874767cd309c5360588d452e608e95d7fb84d7ea85aa29808c44164"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ff1f354ffc9e860ed2c68004cebe783a2d9342078e7df3d959afe9a8c4c1a1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6664bf4fa12e97065b199bb9ca850df09ed7e5644d792a73d1237efc9282ceb1"
    sha256 cellar: :any_skip_relocation, ventura:        "2a7e9e1829cc6c4e6a2673658b79a6d18ff0620040c205f91e9409cedddf931a"
    sha256 cellar: :any_skip_relocation, monterey:       "48af7fb0c5e3d61fac674631786927df9de3b142216c81d6390345511774fc5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "88c7f678edbfa1833802004cae968dd7d5199e262b33925b4ec31140baf2cafa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48fe3e7b6e495f210208a06956ea5603cee22e3627e314b7f8eda5d3d77d8a08"
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
