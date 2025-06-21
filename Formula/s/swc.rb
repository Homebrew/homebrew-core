class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.12.5.tar.gz"
  sha256 "3dd71c2d34d9e1a3aaec769086ed126d1471787179dcac0c27cf896a178e94a2"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42549e039f2789ea3d425c384e0872dc15b7300b92fdb0f486cc62921685aec4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aba0b68f45a96087de0074a9f0ed8652a18d70e91a9a4f98eaba5da597a56fc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "acbbf46610064c5beceec9f22dbddd59831489c31c091ae9e4482eab76a7bdf5"
    sha256 cellar: :any_skip_relocation, sonoma:        "86c4846107c316e3bcc517d8398c7f207cf496e8f84b8aad230d073b74c83740"
    sha256 cellar: :any_skip_relocation, ventura:       "6096838d93ab68d2cbd8f31469598f63957338006f839784b39fd6612ddf4f99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d19ac53666dd69a7296277999db283b157544013dcd43c3336189664d810da4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6a7aef948f8c28c4268ce71f16598195bf7b155b600f120c633756cd82d01e9"
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
