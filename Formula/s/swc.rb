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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d4d9ba29217b7638d64aedc7b826ca0cc25c972274418d1fb06a70911ae9b1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1892094ecefa8e4960c41ee2b6a5fa606dc1b501b4affb3e6e771a7c69bd0def"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30cbfdc1f44c034d00809c68c647961371f338dad6858020a4005a4ef1caeeda"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1ae3e7611dbf887aa734056bd9b89350811f1a3fc0ddc400d1121ef0e88b8d8"
    sha256 cellar: :any_skip_relocation, ventura:       "eb0a7fa3f0e021a500e0224142bce9fe253d74e229866be5843439a04b26fd85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba3ff92a0ff232a3814ca7db0a27a2ebfa48ed525c5896a1de1080d8d5257326"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ceda13a9f38618ec05551266e4ee20e431fc26b121db564289e0237d2ae44d1"
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
