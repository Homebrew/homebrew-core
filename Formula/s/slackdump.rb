class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v4.5.4.tar.gz"
  sha256 "ff51f589a7980a421df1caca3db6e784cb971b3a17997ecc60ff575b5e1742c9"
  license "AGPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "56f4431bd44076156743720250776ad62bb98170b2a4ab2a0b09a9350b3fba5b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "56f4431bd44076156743720250776ad62bb98170b2a4ab2a0b09a9350b3fba5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "56f4431bd44076156743720250776ad62bb98170b2a4ab2a0b09a9350b3fba5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3db989aa1ee02fe1e9dea47cad28ca0ec34ef5ee2610660ea8751fac0cc97827"
    sha256 cellar: :any,                 x86_64_linux:      "3de632ef5d258059d099f7b8a36695fa1d9baa513130e0803cfc34a7f07f6d2e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/slackdump"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackdump version")

    output = shell_output("#{bin}/slackdump workspace list 2>&1", 9)
    assert_match "(User Error): no authenticated workspaces", output
  end
end
