class Taplo < Formula
  desc "TOML toolkit written in Rust"
  homepage "https://taplo.tamasfe.dev"
  url "https://github.com/tamasfe/taplo/archive/refs/tags/0.10.0.tar.gz"
  sha256 "c2f7b3234fc62000689a476b462784db4d1bb2be6edcc186654b211f691efaf8"
  license "MIT"
  head "https://github.com/tamasfe/taplo.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check releases instead of the Git
  # tags. Upstream maintains multiple products in this repo and the "latest"
  # release may be for another product, so we have to check multiple releases
  # to identify the correct version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45ab756df1ba17d564eb5b5132320bd54ed6ce1c87ecd6cc4f060b7c9f464bfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7f802f8658952140d83d60e0c62d3b09532db224f749bd46d4969e094661aea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "468cd6fc7d2fd6604bf1b77b860ab1e0317807aaf799d39810d9ca346029d82f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8e895325722a9a4e7b1c9902f7dea8f9b72091a80433d60090adabc1acae3c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a293f793e6cec6d14e69208ccd45c6190ba4c7e5bf5e38ea9c53d1724d7d1d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28b439cd3525654a6c40bcd74bf47a6f611450daa36f51172991beacb505104e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/taplo-cli", features: "lsp")
    generate_completions_from_executable(bin/"taplo", "completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    test_file = testpath/"invalid.toml"
    (testpath/"invalid.toml").write <<~TOML
      # INVALID TOML DOC
      fruit = []

      [[fruit]] # Not allowed
    TOML

    output = shell_output("#{bin}/taplo lint #{test_file} 2>&1", 1)
    assert_match "expected array of tables", output

    assert_match version.to_s, shell_output("#{bin}/taplo --version")
  end
end
