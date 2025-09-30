class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-tools/community-clients/cli-client/"
  url "https://github.com/camunda-community-hub/zeebe-client-go/archive/refs/tags/v8.6.0.tar.gz"
  sha256 "849c3f951b923dfa2bd34443d47bc06b705cb8faa10d2be5e0d411c238dc1f72"
  license "Apache-2.0"
  head "https://github.com/camunda-community-hub/zeebe-client-go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9815d342170bcaf637c8063e3414537074b11e7c058d2e8f674b57b928ea036"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1489e5d2afe5a0243c62c1387ba42bdd12bceb5882ee85b8f86acea85efb1a7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1489e5d2afe5a0243c62c1387ba42bdd12bceb5882ee85b8f86acea85efb1a7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1489e5d2afe5a0243c62c1387ba42bdd12bceb5882ee85b8f86acea85efb1a7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4245328e2a26df964fcf9afe06ee3859950aaacdb7e1fdcb3e77971188c74c3e"
    sha256 cellar: :any_skip_relocation, ventura:       "4245328e2a26df964fcf9afe06ee3859950aaacdb7e1fdcb3e77971188c74c3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a4691f4d70ecc1d630ae132bcb7f32179197ee2d4b156dc11abfa8045db7b95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93dc50b3cfafaf9fd2fe26864fa7e92fb603d8c097a167c40910a3bef58d3ba3"
  end

  depends_on "go" => :build

  def install
    project = "github.com/camunda-community-hub/zeebe-client-go/v8/cmd/zbctl/internal/commands"
    ldflags = "-s -w -X #{project}.Version=#{version} -X #{project}.Commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:, tags: "netgo"), "./cmd/zbctl"

    generate_completions_from_executable(bin/"zbctl", "completion")
  end

  test do
    # Check status for a nonexistent cluster
    status_error_message =
      "Error: rpc error: code = " \
      "Unavailable desc = connection error: " \
      "desc = \"transport: Error while dialing: dial tcp 127.0.0.1:26500: connect: connection refused\""
    output = shell_output("#{bin}/zbctl status 2>&1", 1)
    assert_match status_error_message, output

    assert_match version.to_s, shell_output("#{bin}/zbctl version")
  end
end
