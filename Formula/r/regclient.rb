class Regclient < Formula
  desc "Docker and OCI Registry Client in Go and tooling using those libraries"
  homepage "https://regclient.org/"
  url "https://github.com/regclient/regclient/archive/refs/tags/v0.11.7.tar.gz"
  sha256 "a648fcf3b5b81c55773f47f6d7401d1904675c32520a76159d960a9e8798badd"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/regclient/regclient.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dfb3204f430873c6f5a7bcbbe605fadbdc26927139c2a1dbbcef5c53a3347487"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dfb3204f430873c6f5a7bcbbe605fadbdc26927139c2a1dbbcef5c53a3347487"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dfb3204f430873c6f5a7bcbbe605fadbdc26927139c2a1dbbcef5c53a3347487"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a0c47b606c25f98f79076a1ac81736a806502f0b95a72cc6891d191cb889bf4f"
    sha256 cellar: :any,                 x86_64_linux:      "b8803ecebbd1a59d25144f8a44609e8052f687ae571c60f2b820102e9863acf2"
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
