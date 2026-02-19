class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "e3dca3e176e0f24764bc2439100a49e75aa91f6b642b24824f260f6f36c3478f"
  license "AGPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a30f1c926955072be30b771a3d93c355bd9fa7529767d96795fc5192cbf1b590"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a30f1c926955072be30b771a3d93c355bd9fa7529767d96795fc5192cbf1b590"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a30f1c926955072be30b771a3d93c355bd9fa7529767d96795fc5192cbf1b590"
    sha256 cellar: :any_skip_relocation, sonoma:        "885561bf7634f34f71d1cb4b0e64329be342d47b31889c2b94820df133b11580"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec66e7c6ae407bbb862487eaaede14311d0867e9724ea32a432016a960ee759e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f07392301ab8d7552240121f791fd178f062673863f3f505a0370cee9863f7dd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/slackdump"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackdump version")

    output = shell_output("#{bin}/slackdump workspace list 2>&1", 9)
    assert_match "(User Error): no authenticated workspaces", output
  end
end
