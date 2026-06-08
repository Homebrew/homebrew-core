class WasmPack < Formula
  desc "Your favorite rust -> wasm workflow tool!"
  homepage "https://wasm-bindgen.github.io/wasm-pack/"
  url "https://github.com/wasm-bindgen/wasm-pack/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "04530d7c215a46cc5468796de3c69fd6620fd78612578545d57f9806aa0c64a4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/wasm-bindgen/wasm-pack.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f5e00e2878b6720a2e6b78143c3d108f315eed4ae2e27d84ab7c06d178370c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e25df58c63956efc5ba5b5eabe677317615f96f19944a630eea91552bc5a685f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "479a15f08423cbe8088c3050bce029b22f30b31c7222589fc8a7ebc2fecd8316"
    sha256 cellar: :any_skip_relocation, sonoma:        "9207047837d68825a4f1fa64962596dfbaf774c94f64da75364dafa5861a5112"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f14fd0596a8f5c3e3b798e12513254fe26bd1e315172073c518a1412fec6c830"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "740daedf0ec40401edd93b035261ca5f571203d36c7f45cf2d6ad5d94c3a45b9"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "rustup"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "wasm-pack #{version}", shell_output("#{bin}/wasm-pack --version")

    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"

    # Prevent Homebrew/CI AArch64 CPU features from bleeding into wasm32 builds
    ENV.delete "RUSTFLAGS"
    ENV.delete "CARGO_ENCODED_RUSTFLAGS"

    # Explicitly enable reference-types to resolve "failed to find intrinsics" error
    ENV["RUSTFLAGS"] = "-C target-feature=+reference-types"

    system bin/"wasm-pack", "new", "hello-wasm"
    system bin/"wasm-pack", "build", "hello-wasm"
    assert_path_exists testpath/"hello-wasm/pkg/hello_wasm_bg.wasm"
  end
end
