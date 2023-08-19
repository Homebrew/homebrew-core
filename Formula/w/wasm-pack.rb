class WasmPack < Formula
  desc "Your favorite rust -> wasm workflow tool!"
  homepage "https://rustwasm.github.io/wasm-pack/"
  url "https://github.com/rustwasm/wasm-pack/archive/v0.12.1.tar.gz"
  sha256 "afa164fec0b119e2c47e38aad9e83351cb414e8ca3c062de292ec8008a45ac09"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rustwasm/wasm-pack.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e205a97851b7166c70355e63b166541b44e6b419db5483ace1fc0ed2d1b87ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1f73a1e067a8bc27645fdbe009a5b2bb3aa289ee88ba541cc0c6964f64add76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13dac57eb2b6b269013ddf52a2dc0adf890a75ac511d1a347c9d0753c926c149"
    sha256 cellar: :any_skip_relocation, ventura:        "6c884e28455fec249ae4fd0d64ce9c653699a1f42e4d9df2cb21b3b4a283c077"
    sha256 cellar: :any_skip_relocation, monterey:       "bd3838f43dd5f2d1fece3ea22d597a019f127ea757625f946193463418c361d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "7540592385c24534fbc9223f65a2361f26082a52f3f717dc40debfe7ae2d250d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0a69f2bb774de2289f5f3bf2fb151d168f1ad07c7e17c2891b4cc85f53948c2"
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
