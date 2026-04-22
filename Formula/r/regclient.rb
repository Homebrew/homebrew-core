class Regclient < Formula
  desc "Docker and OCI Registry Client in Go and tooling using those libraries"
  homepage "https://regclient.org/"
  url "https://github.com/regclient/regclient/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "7d0e0655eed36269980db8df1ac6db30281e99f5bfd5ee6b498b4925cd1667b0"
  license "Apache-2.0"
  head "https://github.com/regclient/regclient.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8dc623e0d8b965a773fa77531f0daeb06266243fca2e580cf54835f22525b3e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dc623e0d8b965a773fa77531f0daeb06266243fca2e580cf54835f22525b3e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dc623e0d8b965a773fa77531f0daeb06266243fca2e580cf54835f22525b3e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3354f01847660af903a2b918dbca97c569c5d4284d7bce815c6175c8ae3b3ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db4eac9c60a922d26dde0acaef1b0564f9942080e7e981224ad99619807787af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dff60c6aada583ffdcf62f4139b51ddf8f1a70d8aec5479497a49cedce04d523"
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
