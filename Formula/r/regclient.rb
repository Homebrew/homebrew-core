class Regclient < Formula
  desc "Docker and OCI Registry Client in Go and tooling using those libraries"
  homepage "https://github.com/regclient/regclient"
  url "https://github.com/regclient/regclient/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "3c0ae9d2570992a94f518c121272471efcc67c2c98fa4b6e94a7758dfaffe183"
  license "Apache-2.0"
  head "https://github.com/regclient/regclient.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ed5a816d0b7d54dc8b66d35c375ba1375b19e680c68baf82db6ad35e7016da4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e160f6e49a188f9bd03e616f77a69c7028003afe7c4b06e14012e32fb2a33d3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15cd9a00a0c7c39684b76e800a68feafe77a090be35746956c0ed53a0d864383"
    sha256 cellar: :any_skip_relocation, sonoma:         "96e44e487d98e369b6f0e72ceac93e4d853e8aeac9ca7c130b94c3276179afa3"
    sha256 cellar: :any_skip_relocation, ventura:        "3785911fc551e075289d32afe37659e84051ea716dbad6381f4871814c540c95"
    sha256 cellar: :any_skip_relocation, monterey:       "c013e046b9b981f7285f5c4e9e75ed4e1c6d4b2b52c0a2eeee6f30b47f7a3dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2956118fd6fb25fa85471d6083276724285850fa914403c5aff69bd0fad6c14b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/regclient/regclient/internal/version.vcsTag=#{version}"
    ["regbot", "regctl", "regsync"].each do |f|
      system "go", "build", *std_go_args(ldflags: ldflags, output: bin/f.to_s), "./cmd/#{f}"

      generate_completions_from_executable(bin/f.to_s, "completion")
    end
  end

  test do
    output = shell_output("#{bin}/regctl image manifest docker.io/library/alpine:latest")
    assert_match "application/vnd.docker.distribution.manifest.list.v2+json", output

    assert_match version.to_s, shell_output("#{bin}/regbot version")
    assert_match version.to_s, shell_output("#{bin}/regctl version")
    assert_match version.to_s, shell_output("#{bin}/regsync version")
  end
end
