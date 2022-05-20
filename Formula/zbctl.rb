class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.0.2",
      revision: "1050d923bd8e891c630458f4f8e47338d8c239bd"
  license "Apache-2.0"
  head "https://github.com/camunda/zeebe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a15342dac131f203c492762097002206caa2f6bdb8ca80b2f277c4221a65648"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a15342dac131f203c492762097002206caa2f6bdb8ca80b2f277c4221a65648"
    sha256 cellar: :any_skip_relocation, monterey:       "90c95487cae2a5722151573a288d90ab2657c7282f70bef2c86db0e5a0f7dcbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "90c95487cae2a5722151573a288d90ab2657c7282f70bef2c86db0e5a0f7dcbe"
    sha256 cellar: :any_skip_relocation, catalina:       "90c95487cae2a5722151573a288d90ab2657c7282f70bef2c86db0e5a0f7dcbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ec785c4664eb7cfefa488c40bc42fea53d5bce70baf909c7a483e8849b77e40"
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
