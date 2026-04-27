class Tinymist < Formula
  desc "Services for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.14.16.tar.gz"
  sha256 "f9c8f33ac4208f7f7d3a56f3005645cb5959fd8bceca56488c7016a0880ebe1c"
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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e0ca08cf27e6dfbc6fa52f69dbcc9c0096979f4b03b6b02f1b745de80490118"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec6dbf0d55d8bb89e2280ea213ce836e678ba2437c0a7078ef035dada36c420e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75573a57ecc654446a01e74a2d8a47e7476d0c5af668f8404c36c5ace3ba6b90"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa8e35d07651f29fbf92c7d99447754550309d1cdc96e506601c2842605e32a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "840213b4c8897d64566894db1721ac38c83b94a91b446e19aa01f2dd0cc415ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c12af290049fde309306c2aba417c57b2954e9873b8b72e994e95102768f2b9"
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
