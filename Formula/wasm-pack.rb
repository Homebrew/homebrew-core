class WasmPack < Formula
  desc "Your favorite rust -> wasm workflow tool!"
  homepage "https://rustwasm.github.io/wasm-pack/"
  url "https://github.com/rustwasm/wasm-pack/archive/v0.11.0.tar.gz"
  sha256 "83a050bfe18f74cdbdce7f0d9fd4c40d00c51eb6de52ee5370e5a2790fc7c096"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rustwasm/wasm-pack.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "055a460d9e3bfc7204b230db14374ba50a2777122b57cf1f9c8b0e217bbf2e06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5cb5868af1846b4b605b1c8286b2688ec8b971bc4eba41a0fc8d00e9c42d56e"
    sha256 cellar: :any_skip_relocation, ventura:        "1a820dcfd66586491f6b2837eb56dc28df6c240ed256f8a610e72240c4aee3de"
    sha256 cellar: :any_skip_relocation, monterey:       "50b13a14546c07336146adb67af2d8d2f77889258743262e80826a800e265ea3"
    sha256 cellar: :any_skip_relocation, big_sur:        "72aed4a7c19fc92bd760940880c230c5d8c33bc01e6221a7bb8b7ba6fef915cc"
    sha256 cellar: :any_skip_relocation, catalina:       "0ebc39126b30ea95fed57827a1d4024b1469d395d473c6731cc9413f3a1a40c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cee90c486fd6e4168cf8399ce7e0c4b231237fb52ecb501ac4df97d9275e86d8"
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
