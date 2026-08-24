class WasmBindgen < Formula
  desc "Facilitating high-level interactions between Wasm modules and JavaScript"
  homepage "https://wasm-bindgen.github.io/wasm-bindgen/"
  url "https://github.com/wasm-bindgen/wasm-bindgen/archive/refs/tags/0.2.127.tar.gz"
  sha256 "b4751fe541a8458ce5858b8e80dee0f39ae43b266192a2062b6038a99cbd1ee3"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4db6e9e9fbbbef0908850a8f3372f8fd24b9d7912d7ff73e55e708e11af9ecf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30ad9b3fe7a5876515ebd56859fc30a215cd8f5610a1e31c1f828b5eda08cc49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8860ec738a1e298160f196362ee6f0bae62312651550ec08430bf39c7175424"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a48b98207bb00d05b1d9eacee56069f087c91c70849de5666b6992e4c8492a3"
    sha256 cellar: :any,                 arm64_linux:   "e9590bee9cf73cebb130fd2d81e7968b36171050605cc19ee41667facdc284d7"
    sha256 cellar: :any,                 x86_64_linux:  "254220e8de2fde7dc286701044666d89ba4fd66a9df1ddb777bcbf5a904431aa"
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
    ENV.append_to_rustflags "-C target-feature=+reference-types"
    system "cargo", "build", "--target", "wasm32-unknown-unknown", "--manifest-path", "Cargo.toml"
    system bin/"wasm-bindgen", "target/wasm32-unknown-unknown/debug/hello_world.wasm",
                              "--out-dir", "pkg", "--reference-types"

    output = shell_output("node index.js")
    assert_match "Hello, World!", output.strip
  end
end
