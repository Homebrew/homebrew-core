class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.11.22.tar.gz"
  sha256 "7ddff83f6e9cad45fe09dcad0dda3e51719ee04b460a2b8e998fb3f300d9526b"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab66222b0beaee538a49e622e65d265b31b173859bb9bc7e6937272233a08ec8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "775b6f42eb5b51f370ed26f02c878e546e0e08456efd6d7116f9da9bf7fe4a72"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f0abe4068c0a8e5654d3541caae828f1e56540d8573e1d8d3269e65ff062c92"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f6c24180bbacd44fbc81d48bf4c6ccef5606054d2ebb893209b02400304eca4"
    sha256 cellar: :any_skip_relocation, ventura:       "8f9930d64b5c2bb803aa895a7900255c8cd84b71fb9b13e17dc80074b988625f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2154e82d25996659a97faa7e772504c111f8d1b7786eea034dee2a9b46ba85be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37ea88af3fab97d5c0b4117f0519d97e3f2d43cb2b31e38bb35e4e2b91acebc8"
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
