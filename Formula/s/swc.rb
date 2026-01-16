class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.15.8.tar.gz"
  sha256 "b5c6099877a9653e026971e21af578a28eaf6db59e6b42be596d204f95827be9"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "389dd97173e10e5442abb2ac8ce2d492722daacb927d06eeb568d9978b4ec019"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd1e6654f2cac4f27142b25635c5310b55db98c46f50e8d2c860514a74038859"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c5de3eb3ed3d2ab1d034521fa4703e3002132506c597502e53fbe92131fba31"
    sha256 cellar: :any_skip_relocation, sonoma:        "805d57c08bfed2af699ac7563db8a977dacbeca23a4bff4010b4197f849ab6bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdc54a04a0d68ba5cb98cc642ae0cbe9a5590cfe67fb9a4ab3b45e71f9833238"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3e27de78846f79a9362d89bf642a232d230a5f5016ab47e0e91a04ee628c519"
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
