class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://github.com/camunda-community-hub/zeebe-client-go"
  url "https://github.com/camunda-community-hub/zeebe-client-go/archive/refs/tags/v8.7.1.tar.gz"
  sha256 "42fc26f985d91c9004ab6cf5a92940789ab0dd9516e7949a4097f1479194e73b"
  license "Apache-2.0"
  head "https://github.com/camunda-community-hub/zeebe-client-go.git", branch: "main"

  bottle do
    manifest_sha256 "86d9af00b5dc08367b7dde028b8abdf926bb5b6358b69dacaeba12d45409d392"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bf98b21e9840d8a849536040cadb75f4971d1848e0ef46c8f59f326a77219dd6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bf98b21e9840d8a849536040cadb75f4971d1848e0ef46c8f59f326a77219dd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bf98b21e9840d8a849536040cadb75f4971d1848e0ef46c8f59f326a77219dd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "56d019b025a5ed475bb084e66b29d271101b7e40d52d2a4ddd2970278de6608d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f6f592caac9128160ecb2268c4f0c3919931b211ec5a604ce02bbf5e5aacd036"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def install
    project = "github.com/camunda-community-hub/zeebe-client-go/v#{version.major}/cmd/zbctl/internal/commands"
    ldflags = "-X #{project}.Version=#{version} -X #{project}.Commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:, tags: "netgo"), "./cmd/zbctl"

    generate_completions_from_executable(bin/"zbctl", shell_parameter_format: :cobra)
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
