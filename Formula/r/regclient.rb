class Regclient < Formula
  desc "Docker and OCI Registry Client in Go and tooling using those libraries"
  homepage "https://regclient.org/"
  url "https://github.com/regclient/regclient/archive/refs/tags/v0.11.5.tar.gz"
  sha256 "ad802e0dcf2852c8e263146227f3430229f911f8404c2a5aa8d4022f13776d8a"
  license "Apache-2.0"
  head "https://github.com/regclient/regclient.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a898a665e7a4f0cfccb8d88f61cc088fdb38d0f2e37e47178599b97658e8a7c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a898a665e7a4f0cfccb8d88f61cc088fdb38d0f2e37e47178599b97658e8a7c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a898a665e7a4f0cfccb8d88f61cc088fdb38d0f2e37e47178599b97658e8a7c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a769d34f8053b6d831c89a2e57cc40d97a111f3b5107b0df2ac16d5a0b4148f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "331018845b5739755a57d4985c1564a8b24c08a5eeb3cceee3a196ec4d5c83ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb6906f8e22a2f44fbe55e6b746ad124450dbf279369e624f9a0a7df1c8cb605"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/regclient/regclient/internal/version.vcsTag=#{version}"
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
