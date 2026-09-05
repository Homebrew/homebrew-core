class WasmBindgen < Formula
  desc "Facilitating high-level interactions between Wasm modules and JavaScript"
  homepage "https://wasm-bindgen.github.io/wasm-bindgen/"
  url "https://github.com/wasm-bindgen/wasm-bindgen/archive/refs/tags/0.2.128.tar.gz"
  sha256 "307bc35a4e2760dd083624e44f4ec4b133bf9808e89927bc46e481e1f927ffbb"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18be261e8bbea3b5db0885a83c0d3317a3368bcb690ff8cdc1a4bb91e093b20c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0beaad3eddc0b1e3157b348382ceca14b3db9161e4763e5eb29a0d5e9f708f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "342b4d9650ffeb9511b0476b80c1f309eb0581855c95ee9a698a463e211c354b"
    sha256 cellar: :any,                 arm64_linux:   "3bbc0387e954ac64dde549af7843323b462f19380cf63b01473837a87c7f1566"
    sha256 cellar: :any,                 x86_64_linux:  "3475e4bf05681d53ae21dd479418bac7d40277b98f4b5bebcc0e508004535f8f"
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
