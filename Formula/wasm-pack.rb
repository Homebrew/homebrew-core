class WasmPack < Formula
  desc "Your favorite rust -> wasm workflow tool!"
  homepage "https://rustwasm.github.io/wasm-pack/"
  url "https://github.com/rustwasm/wasm-pack/archive/v0.10.3.tar.gz"
  sha256 "a4596c08dca32e2f0a1bfe1215421981943b66977846b573c13ea4a7e71fc94c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rustwasm/wasm-pack.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee8e245f0fe26db7df3d63d30d065e64a4f06356f14bbfe0d1e01aadca797fc1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1be0f20de76f8db29f4bbfb31ea25a46bc25ee1ff1ea0d927eb19036644f633"
    sha256 cellar: :any_skip_relocation, monterey:       "68e04907d8c4f477a66b16de4a9b1d10fb036592337e1db1255925444ef0b114"
    sha256 cellar: :any_skip_relocation, big_sur:        "619696e550bb1c00051dec8638ea8aa950f6c1904842830db69ced07e73a51e8"
    sha256 cellar: :any_skip_relocation, catalina:       "b245153ced361da3f7ef37b2323aa46177cb8e1ef6c3b37c76f495bd165fcc7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "247466ad41f870b6de5e73a351d7e4cd7553c394e9c8d5363221c736e8ceaabd"
  end

  depends_on "rust" => :build
  depends_on "rustup-init"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "wasm-pack #{version}", shell_output("#{bin}/wasm-pack --version")

    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    system bin/"wasm-pack", "new", "hello-wasm"
    system bin/"wasm-pack", "build", "hello-wasm"
    assert_predicate testpath/"hello-wasm/pkg/hello_wasm_bg.wasm", :exist?
  end
end
