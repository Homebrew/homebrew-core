class Regclient < Formula
  desc "Docker and OCI Registry Client in Go and tooling using those libraries"
  homepage "https://regclient.org/"
  url "https://github.com/regclient/regclient/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "1685a36a06eba3fdd112f458149ec4561aa68e59839f5a314464037aea291731"
  license "Apache-2.0"
  head "https://github.com/regclient/regclient.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cab820614f821a5f6501910ca0001efb061918d6c1b56dc6811d7354a761a079"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cab820614f821a5f6501910ca0001efb061918d6c1b56dc6811d7354a761a079"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cab820614f821a5f6501910ca0001efb061918d6c1b56dc6811d7354a761a079"
    sha256 cellar: :any_skip_relocation, sonoma:        "94288f5c3127faf1d62c9339c5d45e730296af70312974c5f3272e411f3a2753"
    sha256 cellar: :any_skip_relocation, ventura:       "94288f5c3127faf1d62c9339c5d45e730296af70312974c5f3272e411f3a2753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f54950f93431a802b9cad54bd44e0bc49c8c3bd28c691ae57495f918772a56ae"
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
