class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.1.8",
      revision: "e491a2a024dba1f4e992dc1e4ef3bbdb5cf6b87c"
  license "Apache-2.0"
  head "https://github.com/camunda/zeebe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61a9770af8c97471a34c640f7841349d33711d6245d6c474948adc263004fb7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c0bee650ff10cecb4bcd60f27b022848d22ea7334ed7e0bfe34d6bda7b8e576"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3233dab0e7bac99d9bb34b4ca645af50d918cd49abf6f5530c4641a72386cd88"
    sha256 cellar: :any_skip_relocation, ventura:        "aa6069e582a9a498e224c7996e8815a0ced56c7c5f55b43ebfbbe09734e4bf1a"
    sha256 cellar: :any_skip_relocation, monterey:       "edaf648f0971baf8449f3112805a72facbc589a3a12c9242d777ac248786f316"
    sha256 cellar: :any_skip_relocation, big_sur:        "317b0ea47ea3cbf68acbbfd32d721fbc5600e3769cf1ffb843ce66ba37c453c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28217ef196ec2e7e1faa2ef2f368c1c1220fe150c4c755d1d7e2c3668f05b83b"
  end

  depends_on "go" => :build

  def install
    commit = Utils.git_short_head
    chdir "clients/go/cmd/zbctl" do
      project = "github.com/camunda/zeebe/clients/go/v8/cmd/zbctl/internal/commands"
      ldflags = %W[
        -w
        -X #{project}.Version=#{version}
        -X #{project}.Commit=#{commit}
      ]
      system "go", "build", "-tags", "netgo", *std_go_args(ldflags: ldflags)

      generate_completions_from_executable(bin/"zbctl", "completion")
    end
  end

  test do
    # Check status for a nonexistent cluster
    status_error_message =
      "Error: rpc error: code = " \
      "Unavailable desc = connection error: " \
      "desc = \"transport: Error while dialing dial tcp 127.0.0.1:26500: connect: connection refused\""
    output = shell_output("#{bin}/zbctl status 2>&1", 1)
    assert_match status_error_message, output
    # Check version
    commit = stable.specs[:revision][0..7]
    expected_version = "zbctl #{version} (commit: #{commit})"
    assert_match expected_version, shell_output("#{bin}/zbctl version")
  end
end
