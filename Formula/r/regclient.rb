class Regclient < Formula
  desc "Docker and OCI Registry Client in Go and tooling using those libraries"
  homepage "https://regclient.org/"
  url "https://github.com/regclient/regclient/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "7c60fc5d63dd664b06486cd5156b636f53cd005ff003c1afb7114cd1fe3466ce"
  license "Apache-2.0"
  head "https://github.com/regclient/regclient.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47f8db4df329d70150e04e36831dd22ef5326ad4be299e8ae4f7c99f452c8b70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47f8db4df329d70150e04e36831dd22ef5326ad4be299e8ae4f7c99f452c8b70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47f8db4df329d70150e04e36831dd22ef5326ad4be299e8ae4f7c99f452c8b70"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2b28fb48bd73df4f2189bd9f23a061280771ce6a8a0502642e3243258100355"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de822912a10417876695eb453963b42888f80bb61b53a86183fe5d2a0f2bb02c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93ce74b7cdf8bf980dfd1c399eadcd7b490e658a1c4bde4b043ca5ab30eeaeb9"
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
