class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/refs/tags/v4.2.5.tar.gz"
  sha256 "66cb3c9d795932257f99bd64d8e8720a908e2fdf7a4519d12193a45157fab577"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8bdd8d17b35651ba7bf3f4e187286b6a9fbc5c499c8ffeaae5968e3ea866ec45"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af856cc63e9fe9d4e973c6318717ea25e2f4fa4c46b24f6bd648c10fe37f8657"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de9557d97d0d828f1b7c09f21a2b2713898b997f2c3bb9b9afdcba2c3c473536"
    sha256 cellar: :any_skip_relocation, sonoma:         "31f1576c87c992f21b840bd38c6eda9041eca96ac3aac199d817a3e888ed51c6"
    sha256 cellar: :any_skip_relocation, ventura:        "e89429f77466f325d57efe9255fd819ccd84b9a93b5916c2e22958e5544379f2"
    sha256 cellar: :any_skip_relocation, monterey:       "4b84a753a440015a839ce594a1bebed8fbf87460932cec5b9960f1544e8f7a20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5803c958917c5c8c5789acc2e7ed69a76fe604392dbccd534b9d369e8c7dd363"
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
