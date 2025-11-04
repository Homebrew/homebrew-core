class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "99b5273f83422f7e332660255ec9e583d9076ed13f7bb962339a99a785ab673f"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2943748733bea34e1bf6aaa2839b8872e8c6f902c063062f093040589e0109e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "110ae48ff9ac1c11a71fc5cf5eb8e3ed6b7a82fc415367943febc9714bed6154"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b216fbd3878fc6ccea10fdc18d604f45dcf58d71549ae725e569704dc0b141e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "833320376637c86e75ece8200219ed4a2aee1d6fe41bed8f79547cad77141b14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a5f955663aae9c5d577ddc7046082ce2c459d9945ec86c3b9480a4ea7375f2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70c1dc561ee3b67e6c34cee0afd472c17aef05b0947d2f1262f2653cc607dd3f"
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

    output = shell_output("#{bin}/swc lint 2>&1", 101)
    assert_match "Lint command is not yet implemented", output
  end
end
