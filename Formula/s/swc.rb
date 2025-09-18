class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.13.5.tar.gz"
  sha256 "260cc9039249c1da884649f512eea41508f3fed23d1791a53461b519986bccff"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bac3863669c22f451a5e87a4b2d2546eb16d05cdde3f6b2f5bb076264a3a0156"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "532e2fc113dcf4108fa4c521ba5da59b92f593aec92d612543479374b395cc42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fed98f7d52de2cf2cba26b1afb872b90c9e9beff3ad741f31eaff7386c0f8eb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63c7cbd84e0836f665b4cddf19a9093742b26bd2605301bb70db7672f55f2b93"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a622b028e0fd5ee281e456492f1a28edd75b0e0ce055a70bd23f50de5d98d2b"
    sha256 cellar: :any_skip_relocation, ventura:       "f16395868052eab9085a07279b8a68c0fb7d34c0d02071810e987c85e5b4b47a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "285cb82ec202cd309e024d93ecb4206d80b3842b58006fab5f37ee59cee463df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99a142a3df4de7f52aafbde196b2f4dcc61a778ea24ab5fb98e9e9358711bfb7"
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
