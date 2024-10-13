class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "c6af8119593be975000ebb322c666677579bd39748f5b63592785c1b0628ec86"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5da4e8eb35a041b04816a3559fa89905c98f7f6b1d31097cfd91c2cf57d70bd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4afde51f5b6dbe874c79db21cd14a5cbc2eb8abc9dbbb76052893ae0d55dbb85"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f024defe733c6d8cdbad520c89f8214c50bcfe69afa8bc7b520a0f492363245a"
    sha256 cellar: :any_skip_relocation, sonoma:        "262343bc90e25f038ed469e300df1a25c4ec456365dcb80ad91fefa5d36e86fd"
    sha256 cellar: :any_skip_relocation, ventura:       "6ca5f1311b857116068b7c7e8019271806b07e24f701afa3954abe19f24c8ac4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ceb4746b2778dd083d4c78dc570c0044d85401f584408b4750ce56ee783210a5"
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
