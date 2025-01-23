class Regclient < Formula
  desc "Docker and OCI Registry Client in Go and tooling using those libraries"
  homepage "https://github.com/regclient/regclient"
  url "https://github.com/regclient/regclient/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "31f38400fc3941120130ac3d1271ae31bc9bc586cd28b3bd2e40f89ab93dcdd3"
  license "Apache-2.0"
  head "https://github.com/regclient/regclient.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e183fa6831d91cd9defe312c7d6ad4c787076e4b32a500de93ce07a47a32ad38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e183fa6831d91cd9defe312c7d6ad4c787076e4b32a500de93ce07a47a32ad38"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e183fa6831d91cd9defe312c7d6ad4c787076e4b32a500de93ce07a47a32ad38"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e638dc9a9419dd840e522c23b7a5c7b75b081eb3a11d0359dbf75c472996d3a"
    sha256 cellar: :any_skip_relocation, ventura:       "2e638dc9a9419dd840e522c23b7a5c7b75b081eb3a11d0359dbf75c472996d3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56260bba5f7b2833a21a381f988e70b2331db9e7a8d9efbd68cf37edd185b2cd"
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
