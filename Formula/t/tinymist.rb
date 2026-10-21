class Tinymist < Formula
  desc "Services for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.15.10.tar.gz"
  sha256 "c6ecb0b8a772148fc4864c87b46f9d9d07ad6e6e19ab2ac0f84f2a873c775f1b"
  license "Apache-2.0"
  head "https://github.com/Myriad-Dreamin/tinymist.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "424cf653c45671245231bf87ca641c898c8b20fc6001e5fd08d25037a907dc83"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0ee7308d5f132860d9dbf68d7e4f4df91cd8bcb4a1ceda15f3166d7b36ea5395"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "914504a106c84cdc7830d4097a74c7401bab5ad47b8f2889cf5d816172085951"
    sha256 cellar: :any,                 arm64_linux:       "a3bc8ecd4d7bab621e12dee12aa91ea47f6f2dc7381f55d27b69d45de33db46f"
    sha256 cellar: :any,                 x86_64_linux:      "3efb4837445ba7e918c58eb64bfd43c356e4942bf06863dcf16a43242619f329"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tinymist-cli")
    generate_completions_from_executable(bin/"tinymist", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    system bin/"tinymist", "probe"

    (testpath/"test.typ").write("= Hello from tinymist\n")
    system bin/"tinymist", "compile", "test.typ", "test.pdf"

    assert_path_exists testpath/"test.pdf"
    assert_equal "%PDF-", (testpath/"test.pdf").binread(5)
  end
end
