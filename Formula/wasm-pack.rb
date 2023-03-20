class WasmPack < Formula
  desc "Your favorite rust -> wasm workflow tool!"
  homepage "https://rustwasm.github.io/wasm-pack/"
  url "https://github.com/rustwasm/wasm-pack/archive/v0.11.0.tar.gz"
  sha256 "83a050bfe18f74cdbdce7f0d9fd4c40d00c51eb6de52ee5370e5a2790fc7c096"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rustwasm/wasm-pack.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d51d1215c843c656d850a4cc29b22492a877a8f9dc389b3e73b7356171555bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d54702f096654c9df23e9dd9c6050965a8eb5996e55d46558b1b4a6971d32ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "448a01f33e19ce52bc14c74067655033042c908501d27ff5f4f0be021230ed70"
    sha256 cellar: :any_skip_relocation, ventura:        "5e2e017fe3a6b27aaf3e34d02df8b5690e98d55c518011e5eb1f9e63414a57ff"
    sha256 cellar: :any_skip_relocation, monterey:       "dcbf5195a4b9dcf1cf9fae40c05985814875eddc6f276134daecaffb60d9faad"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd307f923c3a8ae6358383f6ae0126979729aace30c1c20940ff9d9cb28c1fb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d69ef238cb6bd4c668ad6ca938a66678f00d5da6918812cd50b2bb190a06540f"
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
