class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda-cloud/zeebe.git",
      tag:      "1.3.2",
      revision: "2c177b1e87b92117eb69fa24ad42b17e95f1737f"
  license "Apache-2.0"
  head "https://github.com/camunda-cloud/zeebe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b919a7b04b5bd83efb48e31c567e8fcc55363b5009cec5ff4bf0c1c1b270717"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b919a7b04b5bd83efb48e31c567e8fcc55363b5009cec5ff4bf0c1c1b270717"
    sha256 cellar: :any_skip_relocation, monterey:       "5339e4301aacaf22d636fb431e89c0e42cb57b912bc8026818139e696befc815"
    sha256 cellar: :any_skip_relocation, big_sur:        "5339e4301aacaf22d636fb431e89c0e42cb57b912bc8026818139e696befc815"
    sha256 cellar: :any_skip_relocation, catalina:       "5339e4301aacaf22d636fb431e89c0e42cb57b912bc8026818139e696befc815"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaa9fa0d561b3bcaee7cfea7a76cace8ef7306c3351cb41569296b5320762512"
  end

  depends_on "go" => :build

  def install
    commit = Utils.git_short_head
    chdir "clients/go/cmd/zbctl" do
      project = "github.com/camunda-cloud/zeebe/clients/go/cmd/zbctl/internal/commands"
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
