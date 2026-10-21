class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.16.18.tar.gz"
  sha256 "70d900ec369808097018193d18a3888d37266740edf720da79688623560c81d1"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "13e5a9347beb87866215a751d5b35853d788522d7c8d65b8903d52b2f62732ca"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8744d9e11e1ab025c6ffd4eed228020850bd316f0e7347da266d3cb1dd8bb37e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bf19e3250318e8fb3d6c36b7017caaa81f060f3405bbd9b05145d8019070958f"
    sha256 cellar: :any,                 arm64_linux:       "6371320635cada73fc04f2795ba46a0cc624435014f244c47ae1c3e55711a902"
    sha256 cellar: :any,                 x86_64_linux:      "9c13a5733ae5c7ece42ccb8c78a45fe77af862458130d42a383f74e5cde86489"
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
