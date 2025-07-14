class Regclient < Formula
  desc "Docker and OCI Registry Client in Go and tooling using those libraries"
  homepage "https://regclient.org/"
  url "https://github.com/regclient/regclient/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "3bd9e7ad3e3b99d9d11303597a1ce36f7c96d3c84562af47fa6ff552ed869b71"
  license "Apache-2.0"
  head "https://github.com/regclient/regclient.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fc5d037e9035ab926ddfa0425bb8de4c0f48fcf96dcdccff0bada55e21f2027"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fc5d037e9035ab926ddfa0425bb8de4c0f48fcf96dcdccff0bada55e21f2027"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9fc5d037e9035ab926ddfa0425bb8de4c0f48fcf96dcdccff0bada55e21f2027"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea14585ddde60123b5c634acb37b2fecc04c686ed9fead97bba156bfcefa8339"
    sha256 cellar: :any_skip_relocation, ventura:       "ea14585ddde60123b5c634acb37b2fecc04c686ed9fead97bba156bfcefa8339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f613a0c9047153a85f87499161081f49c83422ccc41dabcb6443e643a2bc391"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/regclient/regclient/internal/version.vcsTag=#{version}"
    ["regbot", "regctl", "regsync"].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: bin/f), "./cmd/#{f}"

      generate_completions_from_executable(bin/f, "completion")
    end
  end

  test do
    output = shell_output("#{bin}/regctl image manifest docker.io/library/alpine:latest")
    assert_match "docker.io/library/alpine:latest", output

    assert_match version.to_s, shell_output("#{bin}/regbot version")
    assert_match version.to_s, shell_output("#{bin}/regctl version")
    assert_match version.to_s, shell_output("#{bin}/regsync version")
  end
end
