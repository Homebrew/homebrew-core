class Regclient < Formula
  desc "Docker and OCI Registry Client in Go and tooling using those libraries"
  homepage "https://regclient.org/"
  url "https://github.com/regclient/regclient/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "ce53e082dd289c5f5b4cf0972bc8ff41d02b48114a010784f0f3261cc1c721ad"
  license "Apache-2.0"
  head "https://github.com/regclient/regclient.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9c3b1d71e34f16abc8af12295d0c6d6f49b9c35d200a530bed69ef6854a8124"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ee086607d20229b30ebbf7cec5d8ea366138f4500acb5ac1885299d2e6bdf49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ee086607d20229b30ebbf7cec5d8ea366138f4500acb5ac1885299d2e6bdf49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ee086607d20229b30ebbf7cec5d8ea366138f4500acb5ac1885299d2e6bdf49"
    sha256 cellar: :any_skip_relocation, sonoma:        "715745cdec3c559a0beee810c5d25dec5d9d02077de5e5763dfa4f51b7a3563f"
    sha256 cellar: :any_skip_relocation, ventura:       "715745cdec3c559a0beee810c5d25dec5d9d02077de5e5763dfa4f51b7a3563f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d55e4b69373d1d3720c91b8d0ed0ebd30961ef5a90bebbd414e2d5cf40162e6"
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
