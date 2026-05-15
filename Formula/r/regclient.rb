class Regclient < Formula
  desc "Docker and OCI Registry Client in Go and tooling using those libraries"
  homepage "https://regclient.org/"
  url "https://github.com/regclient/regclient/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "0713a02d4ce888efa0846641e6fe44fb529fa212204aa324aa5589fa672260b2"
  license "Apache-2.0"
  head "https://github.com/regclient/regclient.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18b919f74e339ccda75764879abe44617eda60f3d8e4be65d7d3bb9599406b6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18b919f74e339ccda75764879abe44617eda60f3d8e4be65d7d3bb9599406b6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18b919f74e339ccda75764879abe44617eda60f3d8e4be65d7d3bb9599406b6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff3d2c57d23d5177fdfab3ca6cd65a1e51d9959899b6c29de28009cf24e2c430"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "431023fb5399f0f827b4fb876878eef0e1d352c138d8ae050f0e12144adcee13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b92d0abe21c04569d2b97adfe6de83d185a614c2d9fae932e0cac3ce1a899ce"
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
