class WasmPack < Formula
  desc "Your favorite rust -> wasm workflow tool!"
  homepage "https://rustwasm.github.io/wasm-pack/"
  url "https://github.com/rustwasm/wasm-pack/archive/v0.10.0.tar.gz"
  sha256 "1b89ebb73853b749fdb2bc49474e17cca5658edd3b40723405a6a6cc3e3927fd"
  license "Apache-2.0"
  revision 1
  head "https://github.com/rustwasm/wasm-pack.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "49e5f6aec0c98af3fe8d3145ea5e70d036823a173a4f16ec0829504239c2f0e0"
    sha256 cellar: :any_skip_relocation, catalina: "e3d7080de0f2a638a92818bceb7d744461bc4876f61c9e4432b23daae7c586ad"
    sha256 cellar: :any_skip_relocation, mojave:   "29fab21c9cff3ce852b31580c4cd6777918fdaabd16124f0cfb9fdfdc02c3a60"
  end

  depends_on "rust" => :build
  depends_on "binaryen"
  depends_on "openssl@1.1"
  depends_on "rustup-init"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "wasm-pack #{version}", shell_output("#{bin}/wasm-pack --version")

    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    ENV.prepend_path "PATH", Formula["binaryen"].opt_bin

    system bin/"wasm-pack", "new", "hello-wasm"
    system bin/"wasm-pack", "build", "hello-wasm"
    assert_predicate testpath/"hello-wasm/pkg/hello_wasm_bg.wasm", :exist?
  end
end
