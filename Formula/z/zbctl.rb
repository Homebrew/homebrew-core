class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-tools/community-clients/cli-client/"
  url "https://github.com/camunda-community-hub/zeebe-client-go/archive/refs/tags/v8.6.0.tar.gz"
  sha256 "849c3f951b923dfa2bd34443d47bc06b705cb8faa10d2be5e0d411c238dc1f72"
  license "Apache-2.0"
  head "https://github.com/camunda-community-hub/zeebe-client-go.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c50d697a9616e92dd206e8cd4b017bdd5ff84f2fbf80ce1fd211038d28f8275"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c50d697a9616e92dd206e8cd4b017bdd5ff84f2fbf80ce1fd211038d28f8275"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c50d697a9616e92dd206e8cd4b017bdd5ff84f2fbf80ce1fd211038d28f8275"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4abef43622eccd366d814af4390ecc1f9f8d76290b093d5a1a9f499e9c69dc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66d06b626726ebff2314359c8de8d86ba882340de931cae4a3af33cb65a6ca96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cf35096a17baca1d4c05d682b73f2c6974c2740b37610220054b35fad034d3a"
  end

  depends_on "go" => :build

  def install
    project = "github.com/camunda-community-hub/zeebe-client-go/v#{version.major}/cmd/zbctl/internal/commands"
    ldflags = "-s -w -X #{project}.Version=#{version} -X #{project}.Commit=#{tap.user}"
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
