class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "edcda9a9d5d9507289c84e8527a3a2e46012eb193ba012734f6b5f60ea931491"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e80bb5ccf03f374aad3e4e312ee89a5d1aa4aca331602b250f619544924f226c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23b3bbd50d9c130aed5d1d0ca469bef2bcbc40bee9e76d24f8d8ac3ba6054d17"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa4f6426f46cdebf81961d9651d0b30add7c0bf889ce1aaf5187cf5d69a61a78"
    sha256 cellar: :any_skip_relocation, sonoma:        "84db4decdade0552467feb4fb04f588d3c8b77cde11df68919cd1d4732108563"
    sha256 cellar: :any_skip_relocation, ventura:       "f7b5890f0dd4d0ed9c7cb1b79e10e3d31001c03bda91539e5703dfbca88b1d26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1130f5399021216220c9a59fbc9cec8f32bad5a5ef93bd004a05a74e4dc290aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0087f4ab7bf6638731d07ba3b5eafc7011f68939bbf7fd71d247e6b1422ecd0"
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
