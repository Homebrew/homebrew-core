class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.0.0",
      revision: "74e2dae4e112d0ecd600d1b55cbc588609b792a7"
  license "Apache-2.0"
  head "https://github.com/camunda/zeebe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "756a677a5506248f15392c4a7961d7599c555a69742266d895c6e0291527c561"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "756a677a5506248f15392c4a7961d7599c555a69742266d895c6e0291527c561"
    sha256 cellar: :any_skip_relocation, monterey:       "83437527de58b2ae9b4a55a4b03b70dedca6b67db530e1102dff73a0d9986c91"
    sha256 cellar: :any_skip_relocation, big_sur:        "83437527de58b2ae9b4a55a4b03b70dedca6b67db530e1102dff73a0d9986c91"
    sha256 cellar: :any_skip_relocation, catalina:       "83437527de58b2ae9b4a55a4b03b70dedca6b67db530e1102dff73a0d9986c91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ead9c7df44363b4499c3feae2081ca71fa80f06e1168cb9942370bb157625c39"
  end

  depends_on "go" => :build

  def install
    commit = Utils.git_short_head
    chdir "clients/go/cmd/zbctl" do
      project = "github.com/camunda/zeebe/clients/go/cmd/zbctl/internal/commands"
      ldflags = %W[
        -w
        -X #{project}.Version=#{version}
        -X #{project}.Commit=#{commit}
      ]
      system "go", "build", "-tags", "netgo", *std_go_args(ldflags: ldflags)
    end
  end

  test do
    # Check status for a nonexistent cluster
    status_error_message =
      "Error: rpc error: code =" \
      " Unavailable desc = connection error:" \
      " desc = \"transport: Error while dialing dial tcp 127.0.0.1:26500: connect: connection refused\""
    output = shell_output("#{bin}/zbctl status 2>&1", 1)
    assert_match status_error_message, output
    # Check version
    commit = stable.specs[:revision][0..7]
    expected_version = "zbctl #{version} (commit: #{commit})"
    assert_match expected_version, shell_output("#{bin}/zbctl version")
  end
end
