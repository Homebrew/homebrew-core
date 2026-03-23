class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.15.21.tar.gz"
  sha256 "254424fb8878443df7e6733174e76224b9a2a420cc3f2f8086e31ff0ed5d86a7"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00e1503d0e4609b3e1331fa0cc7106e4f224d7f9e408aeb3f377a0e7f36c53bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd05bc8f36e496afeea7fa46318c03589a554b9d7de23cca1180d30a19c7e585"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c42ba7e7170f251855dcbc42df991d39f88787c0734ea7ba11e597da8239468"
    sha256 cellar: :any_skip_relocation, sonoma:        "82bc7d7d1a40922380bb0ba9fdc42fac74babfe35d7bc64ff432d19305647282"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df452b48b9538c7024130604c923c33f80f9c9912ebf3361441ba7fe531e9fbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3798810651e34ee74bdd77f1f556983f9d84358677dd28a1ba3f95c71a3214e3"
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
