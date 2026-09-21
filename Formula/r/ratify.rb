class Ratify < Formula
  desc "Artifact Ratification Framework"
  homepage "https://ratify.dev"
  url "https://github.com/notaryproject/ratify/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "fc1304714e395f60a77ec71e03453841b36eb7afb4798179886377bca6778629"
  license "Apache-2.0"
  head "https://github.com/notaryproject/ratify.git", branch: "main"

  # Upstream moves the tag until a release is finally made and marked as latest,
  # so we have to use the `GithubLatest` strategy to avoid picking up a pre-release.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6dad4018a334c852684758229cd41b0028cd2484646d1c48b13e8649924770cf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b44f1015ead3db953c8dd5444c2a09859583ee4aa76aa041260677b13d250d96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "960f47f1576f72aade6e642ab00f9261e5e7db1426caf80a2cfb579570c5274c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "39fa719e93883e633e41c70de072509420fd7cd46ac917f25860e2965c1a1af9"
    sha256 cellar: :any,                 x86_64_linux:      "39e6bb565176673178aa91f62fa162f9056153866438d128f1d907f16b5ff421"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/ratify-project/ratify/internal/version.GitTag=#{version}
      -X github.com/ratify-project/ratify/internal/version.GitCommitHash=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/ratify"

    generate_completions_from_executable(bin/"ratify", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ratify version")

    test_config = testpath/"ratify.json"
    test_config.write <<~JSON
      {
        "store": {
          "stores": [
            {
              "name": "example-artifact",
              "type": "oras",
              "settings": {}
            }
          ]
        },
        "policy": {
          "policies": []
        },
        "verifier": {
          "verifiers": []
        },
        "executor": {},
        "logger": {
          "level": "info"
        }
      }
    JSON

    example_subject = "example.com/artifact:latest"
    output = shell_output("#{bin}/ratify verify --config #{test_config} --subject #{example_subject} 2>&1", 1)
    assert_match "referrer store config should have at least one store", output
  end
end
