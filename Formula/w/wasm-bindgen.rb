class WasmBindgen < Formula
  desc "Facilitating high-level interactions between Wasm modules and JavaScript"
  homepage "https://wasm-bindgen.github.io/wasm-bindgen/"
  url "https://github.com/wasm-bindgen/wasm-bindgen/archive/refs/tags/0.2.122.tar.gz"
  sha256 "3ea60c7c7dffbd4ea1898c5a0046c6ccd4a53d5638f231238936b5464e49d161"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8120153ea5f40ea13240696e0bcd184dd2ff2961ae9955d3410826659a4e6d34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "141a0c0addd36ea3f9c3526a38852b3ff12bfbb567757ba3270e33b65593b6a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b9199996c9f4241d581d0d808e5f89a2571c749be1bcb938dfaa11bb1e6adc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0c30ad1dd95c362b9830013b854c199c17a09316825d063e37494ad92f27cd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "851008caefc45389d3941c51a2e6d180360fea7f2fb7d039f5b2a4775dd003e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "219454268767dd291bb95b5bb02be663349e0904f8215ae97f5d0d1f4027aee7"
  end

  depends_on "rust" => :build
  depends_on "node" => :test
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wasm-bindgen --version")

    (testpath/"src/lib.rs").write <<~RUST
      use wasm_bindgen::prelude::*;

      #[wasm_bindgen]
      extern "C" {
          fn alert(s: &str);
      }

      #[wasm_bindgen]
      pub fn greet(name: &str) {
          alert(&format!("Hello, {name}!"));
      }
    RUST
    (testpath/"Cargo.toml").write <<~TOML
      [package]
      authors = ["The wasm-bindgen Developers"]
      edition = "2021"
      name = "hello_world"
      publish = false
      version = "0.0.0"

      [lib]
      crate-type = ["cdylib"]

      [dependencies]
      wasm-bindgen = "#{version}"
    TOML
    (testpath/"package.json").write <<~JSON
      {
        "name": "hello_world",
        "version": "0.0.0",
        "type": "module"
      }
    JSON
    (testpath/"index.js").write <<~JS
      globalThis.alert = console.log;
      import { greet } from './pkg/hello_world.js';

      greet('World');
    JS

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"
    system "rustup", "target", "add", "wasm32-unknown-unknown"

    # Prevent Homebrew/CI AArch64 CPU features from bleeding into wasm32 builds
    ENV.delete "RUSTFLAGS"
    ENV.delete "CARGO_ENCODED_RUSTFLAGS"

    # Explicitly enable reference-types to resolve "failed to find intrinsics" error
    ENV["RUSTFLAGS"] = "-C target-feature=+reference-types"
    system "cargo", "build", "--target", "wasm32-unknown-unknown", "--manifest-path", "Cargo.toml"
    system bin/"wasm-bindgen", "target/wasm32-unknown-unknown/debug/hello_world.wasm",
                              "--out-dir", "pkg", "--reference-types"

    output = shell_output("node index.js")
    assert_match "Hello, World!", output.strip
  end
end
