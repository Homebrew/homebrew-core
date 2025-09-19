class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.13.9.tar.gz"
  sha256 "b6553c496766870ffc84f9d6a8f5f9ada9f47426abf09dd0274d6100b1e87f49"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03572171a7e1c5d3e8f3408fd231770b180793de72d5e271c1be081e220c0f31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67bd2d8b2919f7dc7749f7f0e888c47542280c52bd1706d43fbfa9c2699a4b38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "750115245a410c824f5e2f167acea94a66a0563c6d181400c249ff005d72475f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9c1ec4f88ebbe174e0f3d94cdaad7ff97c09fa2332eaded3c545f5ac1f1fb8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "808b26a13e1fe7c9b304340a5b1e827cfe2fa5391289332b28357461d2c4f81c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02d39c2154392b9e99369533ff781e2319e680585c1c37c75d3353d22e075963"
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
