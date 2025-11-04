class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "99b5273f83422f7e332660255ec9e583d9076ed13f7bb962339a99a785ab673f"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da0360d3af994089e2c7e7f82342173a9ab678e94e19a4b476c0c7bc0daffd86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86531067cda6515a3a3bd1a77d9bf6686832eeaa2d0c5413491bf46ca456b98b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dfeaef55c7937ac7a40be413c9fcb46859a2843707ddf647d7ac7d9e61ab2f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a68966de88e66731fd8d6b4a13e50145731d9ea04d2a2ee6ef8524acca95ddab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acd4461e335db664d3fb86bfb3c95566ce1778e297adeccbc761403206cf0186"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbc7fcf60fe84a42cd60631d56811752f82274a19846cf5b989e164c2f95a92d"
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
