class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.15.40.tar.gz"
  sha256 "3773f1003b9c7750a8bfc60aea9d9816df01b3f0856cc37e58b7108c28f0e5e2"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64f0faa673723cacdbeac74fb3b5d9cef615c45879b5367f6de60f7c696fa254"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6fadefb8906e2992a7a3d9a2e90f71bb4f1e6bb96ce2b66af026af2856ce04c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be86327599beed0ea505baad1bfb06be5ab3b7d2f7347b87a6fac617aad6d93b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c2668b9ef009bba7b1f1a7d61f6c99e4ad62084b3f29716faa81693ae3f310f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef8542758d4e19f7fa18401d4ea3819b8281c984f19bd6dfe07ee82a88701a61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b93e5a3dfc81e05fd4c693a096ed4ea0689ff3548380d67cd128fa27f9438e2d"
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
