class WasmPack < Formula
  desc "Your favorite rust -> wasm workflow tool!"
  homepage "https://wasm-bindgen.github.io/wasm-pack/"
  url "https://github.com/wasm-bindgen/wasm-pack/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "5e72eb8eb73091ef6376d1a9d2b33a45e727970f29c75664b4a969cb437fccb2"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 1
  head "https://github.com/wasm-bindgen/wasm-pack.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a0afec3efc61040915e16f669ea2d0ae9780eb503212dea1a4800a9ebe50ec65"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5065e2dd622f289ac44e52174dd11cece94eb7e57f1f6ce627c94a7402575e78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "03fc65f8f5ef0270850133d3ca545a49e211b9e30fcc9419eb134ac85a3bac52"
    sha256 cellar: :any,                 arm64_linux:       "24638b7bc4315a3a2e8236e555dcf2493c9044622125afaafa932d21a63e26dd"
    sha256 cellar: :any,                 x86_64_linux:      "3d046831096b640c15e9be8d8ffaf20f6499fd5f7d54211f9c752ae1a1c6c992"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "wasm-pack #{version}", shell_output("#{bin}/wasm-pack --version")

    ENV.prepend_path "PATH", formula_opt_bin("rustup")
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"

    # Prevent Homebrew/CI AArch64 CPU features from bleeding into wasm32 builds
    ENV.delete "RUSTFLAGS"
    ENV.delete "CARGO_ENCODED_RUSTFLAGS"

    # Explicitly enable reference-types to resolve "failed to find intrinsics" error
    ENV.append_to_rustflags "-C target-feature=+reference-types"

    system bin/"wasm-pack", "new", "hello-wasm"
    system bin/"wasm-pack", "build", "hello-wasm"
    assert_path_exists testpath/"hello-wasm/pkg/hello_wasm_bg.wasm"
  end
end
