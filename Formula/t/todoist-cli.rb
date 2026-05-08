class TodoistCli < Formula
  desc "CLI for Todoist"
  homepage "https://github.com/sachaos/todoist"
  url "https://github.com/sachaos/todoist/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "1993d51b1d6fe85c521bc215584674631bef59fe1e9a4e29cf19d921e8df303f"
  license "MIT"
  head "https://github.com/sachaos/todoist.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e76e81f52e18234babc96982bcb2610cf65931d5ecd6b8ca64a49f67e586e28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e76e81f52e18234babc96982bcb2610cf65931d5ecd6b8ca64a49f67e586e28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e76e81f52e18234babc96982bcb2610cf65931d5ecd6b8ca64a49f67e586e28"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c94087d6916eb0664300379de1872d977f5653a785faacfc00d18b09516d08e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81e1f3ffdf796e7ea5df27e49f35348878c618cfc774caf2f77529029d19e133"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12308761800834d8f19f565a017031928153aa376e31ccbca57efc73f7673911"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(output: bin/"todoist", ldflags:)
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
