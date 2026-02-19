class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.15.11.tar.gz"
  sha256 "00f3637f8108c632be5ce2994cc09cc2e9f3d3e15a45b97687a4886c224124bc"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e903894cdf4a332206bce95816a3aade8b147a22014d1db74356f0b34e6135f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8f68a187b222017ae64e413416f7a5270a87fcc3639bf080809c0730f29989c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fe36c46a86456d166e5870aaf4211c53fb38773a5220e7a9a6480263875be9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "50eac08d5b7b447fd5d94ca40950c9f18dece5581db02a8a0a3eb3d639f1648d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e18364c5fb8507209b1e3c82b2710f1691313f41d7048d562686ab1bd506b62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e0ea33730f8ae0a57c7c719f09c22f03e88d46e4e03747529f0889168db89cd"
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
