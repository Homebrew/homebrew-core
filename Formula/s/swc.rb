class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.11.20.tar.gz"
  sha256 "3ec9b144b90e3c7b488c630dd57e5527734cacd8e609b42600fdf32fc05fc748"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba8c72f805658971e7dd878fb02b2722a7c64c4a55e4555c7b33e109567bea43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76929c7f4fddec17509e329a4c4d81c19167337bdd2c32d579128090512b7424"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d508e465c054c226e2a4c4150e77e7220243dda8bc8ae3bf4c0f0cfaa12ef45"
    sha256 cellar: :any_skip_relocation, sonoma:        "572f3755696ba669047366548678c34fba092e994658b9f74df134ae056c60f0"
    sha256 cellar: :any_skip_relocation, ventura:       "590ff92f5896a5cc325056ae6070a46cf9c4be24c7427e74468402ac63e68bb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d582170d646cf07cfd60e3f0680cd255e022aee92fefb9c82a0176b7d96bd4f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9798b517157fa03426ef2a7a2746f0ba084ec9b19f676b4bb3fe037fc88469b"
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
