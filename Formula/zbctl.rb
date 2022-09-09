class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.0.6",
      revision: "eab2ac867d0dba7208b2322679085f395bbb6db2"
  license "Apache-2.0"
  head "https://github.com/camunda/zeebe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73c0ff4dc5da7feaa11cff07f19c4a74ba70fac25e57570d52f600c466a6459a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73c0ff4dc5da7feaa11cff07f19c4a74ba70fac25e57570d52f600c466a6459a"
    sha256 cellar: :any_skip_relocation, monterey:       "197d44a4847757c73643e5d6bbed635315c6edb2ce19aade3013e084870ed1bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "197d44a4847757c73643e5d6bbed635315c6edb2ce19aade3013e084870ed1bd"
    sha256 cellar: :any_skip_relocation, catalina:       "197d44a4847757c73643e5d6bbed635315c6edb2ce19aade3013e084870ed1bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0783c0726d603bd6a0ce2e23fa21c86c079f16ea9420590c441f807e8036c35"
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
