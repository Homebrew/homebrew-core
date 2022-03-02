class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda-cloud/zeebe.git",
      tag:      "1.3.5",
      revision: "a3abd00949456ff2c4510de34809496afb48f7ee"
  license "Apache-2.0"
  head "https://github.com/camunda-cloud/zeebe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3739bfa2931d53f991f9abc52d0b3c12ca4c459e17c634df19d692df780a0d51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3739bfa2931d53f991f9abc52d0b3c12ca4c459e17c634df19d692df780a0d51"
    sha256 cellar: :any_skip_relocation, monterey:       "a289534edef4e2da948bee894f9cb18efb682607da3ea7a1e3449d46944fab0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a289534edef4e2da948bee894f9cb18efb682607da3ea7a1e3449d46944fab0e"
    sha256 cellar: :any_skip_relocation, catalina:       "a289534edef4e2da948bee894f9cb18efb682607da3ea7a1e3449d46944fab0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6ff83198abf8a64855801d9c1f8e3e861e0347e74e9023252a1cf1af4975c71"
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
