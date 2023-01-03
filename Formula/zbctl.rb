class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.1.6",
      revision: "f86418c0a6b07a32bfd5476a4d228def3482ae41"
  license "Apache-2.0"
  head "https://github.com/camunda/zeebe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f150dba966e39cc6f374782d780e76e285b98459a0726b095303e0b8a9c0f399"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f150dba966e39cc6f374782d780e76e285b98459a0726b095303e0b8a9c0f399"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f150dba966e39cc6f374782d780e76e285b98459a0726b095303e0b8a9c0f399"
    sha256 cellar: :any_skip_relocation, ventura:        "fb45b726db000df211abcc7b7e02c4c2a80e43ec78ab2c6ff041f578d4ab9949"
    sha256 cellar: :any_skip_relocation, monterey:       "fb45b726db000df211abcc7b7e02c4c2a80e43ec78ab2c6ff041f578d4ab9949"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb45b726db000df211abcc7b7e02c4c2a80e43ec78ab2c6ff041f578d4ab9949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b71ce643b549533e4fa93ccc95097c1df2c4552b58b3767c895d2238a1a63278"
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
