class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.15.30.tar.gz"
  sha256 "00ef86ca91e7bc961acb9ad67236baa8d5b19535306e1657d49c0b79ac2ea097"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8bc9f4ec6b8869f6e392255a805d0ee6cffd36d32132d693e46cdeac301c98b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fdb1ec1583ced8fc1625b7cf9ecc642fefa1b68acf386ef8c484813e4c4b55d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63995e73bac9d9fd871f91094356a6913fc4aa98eecb9f45528887db2541839c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b82c55f9af2830c50def15871c29fe99f8d2fc9086c84b6879a1ad8224fa817"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "911d37205cec1542513ff33824de00db71faad4ccc40b0dbf9a3d808122e174c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65535980330f28958b4022fd7923d4f1628445eab1b765824129dc28ceaf98e2"
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
