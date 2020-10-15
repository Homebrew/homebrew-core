class WasmPack < Formula
  desc "Your favorite rust -> wasm workflow tool!"
  homepage "https://rustwasm.github.io/wasm-pack/"
  url "https://github.com/rustwasm/wasm-pack/archive/v0.9.1.tar.gz"
  sha256 "56930d1f15bbcc85771e9b8e5c1b7bb6734b2c410c353ecd11eae828e35d5fb0"
  head "https://github.com/rustwasm/wasm-pack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "349d47601c15c1639f9a2c303544addd05b6178a0ae9c3dff15ce53f74d2dfc6" => :catalina
    sha256 "3fa2dd4e71144a07b14323486a31ef12065d31b90e30c30394f2833b205781db" => :mojave
    sha256 "f6bc091f507521b82e308a1f1aabdaa1e6afdae80e3beaa0c097bf5702e55c1e" => :high_sierra
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
