class TodoistCli < Formula
  desc "CLI for Todoist"
  homepage "https://github.com/sachaos/todoist"
  url "https://github.com/sachaos/todoist/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "2987f9919b61609e121aaee4fd3296c40c7e5437784c84eb707a55dc0757ad9b"
  license "MIT"
  head "https://github.com/sachaos/todoist.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe24f3a9167095be7987e52601190e1b6ed8f8a0b09cf88320e7bf63db186a0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe24f3a9167095be7987e52601190e1b6ed8f8a0b09cf88320e7bf63db186a0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe24f3a9167095be7987e52601190e1b6ed8f8a0b09cf88320e7bf63db186a0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "455337aed4d77945998de06dba80a3031f69bd537565052286109112a349990a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f49c51e0fe56cf86e2eab8c4d542601e980236fae1d7f0cf6d5934132b8f7d85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10c3e7eb3366de978e1ba7ad6a495ad9d26b99101eebdb8ab19c655190c2f8e5"
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
