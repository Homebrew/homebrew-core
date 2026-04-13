class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.15.24.tar.gz"
  sha256 "0a45f37aa61affb76c391101452faea9588e174b4c9bcaf1ee4a349c3ae1c271"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eef87bcf2cc797fdb793faf7efe2716ea7c5b372e274495795178db30ed68247"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd3ad83b8e3ef2ce7cae587c86b15c7da317f8baf0c77d860f0630bbcb60a995"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ae24bfe22354be8b21d27f6981728d1a651c2581d2b4ed86b878e875e9af363"
    sha256 cellar: :any_skip_relocation, sonoma:        "7649d48deaf5cc7fa30ff3cdc648d0dd7efd81d54ab5f9704b230cc6763440c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d185376168fd02353928d6f71eade61b6bcaeed434dc93180a726990930dce8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e637fe03c6c79f0c2699fcb2b6b1dc7fcadc6c1c12df2de6c036ac05542c11c"
  end

  depends_on "rust" => :build

  def install
    # `-Zshare-generics=y` flag is only supported on nightly Rust
    rm ".cargo/config.toml"

    system "cargo", "install", *std_cargo_args(path: "crates/swc_cli_impl")
  end

  test do
    (testpath/"test.js").write <<~JS
      const x = () => 42;
    JS

    system bin/"swc", "compile", "test.js", "--out-file", "test.out.js"
    assert_path_exists testpath/"test.out.js"

    output = shell_output("#{bin}/swc lint 2>&1", 134)
    assert_match "Lint command is not yet implemented", output
  end
end
