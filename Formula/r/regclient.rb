class Regclient < Formula
  desc "Docker and OCI Registry Client in Go and tooling using those libraries"
  homepage "https://regclient.org/"
  url "https://github.com/regclient/regclient/archive/refs/tags/v0.11.6.tar.gz"
  sha256 "6e1d1ba693e0bb47afe6e32fd85513cbb78dc20d9564b5de380a6b5e275a7c83"
  license "Apache-2.0"
  head "https://github.com/regclient/regclient.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "924899cd61035413a0fc7755d9f774e083e3a03c2e0ffba41ec04c0ded73fce2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "924899cd61035413a0fc7755d9f774e083e3a03c2e0ffba41ec04c0ded73fce2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "924899cd61035413a0fc7755d9f774e083e3a03c2e0ffba41ec04c0ded73fce2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "924899cd61035413a0fc7755d9f774e083e3a03c2e0ffba41ec04c0ded73fce2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "86147298c044120128c6122784fd72a3ffcc1d4b355397b333d74d9f471a8cd5"
    sha256 cellar: :any,                 x86_64_linux:      "8dc66fd47e77afe3839bcf58ff1a95ef6a2abc9233bf1827dbb4da2ba942b1c1"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/regclient/regclient/internal/version.vcsTag=#{version}"
    ["regbot", "regctl", "regsync"].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: bin/f), "./cmd/#{f}"

      generate_completions_from_executable(bin/f, shell_parameter_format: :cobra)
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
