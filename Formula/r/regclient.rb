class Regclient < Formula
  desc "Docker and OCI Registry Client in Go and tooling using those libraries"
  homepage "https://github.com/regclient/regclient"
  url "https://github.com/regclient/regclient/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "17042a6f8b5d5bf25ce916347a0b314f7dd91a6c06f78761a4e5fe21f5eb9632"
  license "Apache-2.0"
  head "https://github.com/regclient/regclient.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ca7fa78e26d67310edf9b7cc05ec983d482b10a55380dab15986957c272bf6c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccc8589896360f67f531d8dabc0a5866c6212d541429d08355cbca3a08f36efe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "606e9cf5ab33c8581eb121bf2a11ab188e34c9f900cd326ccbcf27a6836224e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9aec13a3b0031fa746d9e4c83573a77616424dfd1abecf35ea100767891fd7c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "f92f19447dc4d2cc4d6144b7e6ee1191ae92aea794d15dc0f6240ab1feecfad8"
    sha256 cellar: :any_skip_relocation, ventura:        "252ca40cc735e7400ba2bda2013c7d44a04a320d1a2889cc867ac862b6dd2e36"
    sha256 cellar: :any_skip_relocation, monterey:       "cf4be119832a9e790217e99955077785d511b347fe419905873673429a23abf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f442b906bb0c4c7ab062cc53fda6609853c23f78e649cc300811edcc72dddc49"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/regclient/regclient/internal/version.vcsTag=#{version}"
    ["regbot", "regctl", "regsync"].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: bin/f), "./cmd/#{f}"

      generate_completions_from_executable(bin/f, "completion", base_name: f)
    end
  end

  test do
    output = shell_output("#{bin}/regctl image manifest docker.io/library/alpine:latest")
    assert_match "application/vnd.docker.distribution.manifest.list.v2+json", output

    assert_match version.to_s, shell_output("#{bin}/regbot version")
    assert_match version.to_s, shell_output("#{bin}/regctl version")
    assert_match version.to_s, shell_output("#{bin}/regsync version")
  end
end
