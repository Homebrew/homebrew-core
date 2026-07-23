class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer.git",
    tag:      "v7.2.1",
    revision: "c14032594b893b40e9b71456d504cf55c141c8f6"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d2186e336a958fe000655a7a685a7d57085203be8107aced5066a3b39855006"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a632883f99b22663561c2eb48ec892e1f7443b49a33eed1366acc9261ffdbc3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ad9394ae992082d198a1083e85f33f6bbec9367c3f7a49aa4248185c41e3a08"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba74d9b71a8097a77397607c939a84e52354dc460fc6e23759de289db71aeb3e"
    sha256 cellar: :any,                 arm64_linux:   "0651d97fcbdb81e446bd8ab5be1d28168626fac90b1c90e532d5ea2d3f4dc22a"
    sha256 cellar: :any,                 x86_64_linux:  "0d27061b5adba6174e2749f4862d48a01fe11576adfe4ea288f2b10c026436f4"
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
