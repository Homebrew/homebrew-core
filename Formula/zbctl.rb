class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.1.0",
      revision: "9233af41da323e67867ad1896eaeb59730880f43"
  license "Apache-2.0"
  head "https://github.com/camunda/zeebe.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68180e5dd7e8098a3dbf1d7c6d401e40e3702f7584d38737393fea1838e26cd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68180e5dd7e8098a3dbf1d7c6d401e40e3702f7584d38737393fea1838e26cd7"
    sha256 cellar: :any_skip_relocation, monterey:       "f884af4e4358cb08c75bdf17796bccef0cf7307678a00875c439ce69d32e9593"
    sha256 cellar: :any_skip_relocation, big_sur:        "f884af4e4358cb08c75bdf17796bccef0cf7307678a00875c439ce69d32e9593"
    sha256 cellar: :any_skip_relocation, catalina:       "f884af4e4358cb08c75bdf17796bccef0cf7307678a00875c439ce69d32e9593"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5572a625db90dfc1689bf22bb9b53b2c165136f1d405ad13ff78f2510f2a46bd"
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
