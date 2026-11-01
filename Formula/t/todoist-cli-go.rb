class TodoistCliGo < Formula
  desc "CLI for Todoist"
  homepage "https://github.com/sachaos/todoist"
  url "https://github.com/sachaos/todoist/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "4ff262c32714901a7f978f7d775f43874de5784bc8d28ca3eb163bddf83a815e"
  license "MIT"
  head "https://github.com/sachaos/todoist.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "90791bd8a47694f6988629bdf75f2787116c77476d2d0b37f1facb1edf95e7c1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "90791bd8a47694f6988629bdf75f2787116c77476d2d0b37f1facb1edf95e7c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "90791bd8a47694f6988629bdf75f2787116c77476d2d0b37f1facb1edf95e7c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "17ec90e8e4c101b2b802d0d7a4849c30433e3872a202d658bff4b80e864f7221"
    sha256 cellar: :any,                 x86_64_linux:      "0d6b5d208ca961206807d90a70cd6e2e67855fcee4b0ed0dec73a1ec3b0a4165"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(output: bin/"todoist", ldflags:)
  end

  def caveats
    <<~EOS
      This formula was renamed from "todoist-cli" to "todoist-cli-go" to
      free up the "todoist-cli" name for the official Doist CLI
      (https://github.com/Doist/todoist-cli).
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/todoist --version")

    test_config = testpath/".config/todoist/config.json"
    test_config.write <<~JSON
      {
        "token": "test_token"
      }
    JSON
    chmod 0600, test_config

    output = shell_output("#{bin}/todoist list 2>&1")
    assert_match "There is no task.", output
  end
end
