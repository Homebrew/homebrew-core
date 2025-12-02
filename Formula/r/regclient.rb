class Regclient < Formula
  desc "Docker and OCI Registry Client in Go and tooling using those libraries"
  homepage "https://regclient.org/"
  url "https://github.com/regclient/regclient/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "5eeb1cd34d5f004447739fad5980af50bfd5349ace6673e7928efb57b85198c0"
  license "Apache-2.0"
  head "https://github.com/regclient/regclient.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05773b173167055d874ab3f5e9261873ada1bb3bd47962305bb76e062f5a5639"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05773b173167055d874ab3f5e9261873ada1bb3bd47962305bb76e062f5a5639"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05773b173167055d874ab3f5e9261873ada1bb3bd47962305bb76e062f5a5639"
    sha256 cellar: :any_skip_relocation, sonoma:        "88d9b91e327510f7e994e8df8a6b949404a921dc35522e223dab2a8eca67a81a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0c4299e69929d05346a6e131cc39c2751133a01a09d1ce9744fc024445fb68f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68223413fb393093a98d336f7e9b499c29e5b70c68e8253569bf44cb75f4c503"
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
