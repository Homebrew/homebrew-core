class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/refs/tags/1.0.1.tar.gz"
  sha256 "6cb16e89cd1964c95217c347c1b5a19c930b9125c14976dbd92d46cc324e4aa6"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cff33b330f8f8b9d5ba43c7175d4a7dcfe51857313fc309f837c46835d05c8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cff33b330f8f8b9d5ba43c7175d4a7dcfe51857313fc309f837c46835d05c8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9cff33b330f8f8b9d5ba43c7175d4a7dcfe51857313fc309f837c46835d05c8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "41d5547e243239fd11d62cd2b48822a44c0714ad931502e47e0547fdad278ca0"
    sha256 cellar: :any_skip_relocation, ventura:       "41d5547e243239fd11d62cd2b48822a44c0714ad931502e47e0547fdad278ca0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8cf8a480932a940394db11fd41991d3f79b4402c907180e9007edcfe12e864e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X cmd.Version=#{version}", output: bin/"vt"), "./vt"

    generate_completions_from_executable(bin/"vt", "completion")
  end

  test do
    output = shell_output("#{bin}/vt url #{homepage} 2>&1", 1)
    assert_match "Error: An API key is needed", output
  end
end
