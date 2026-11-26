class Ratify < Formula
  desc "Artifact Ratification Framework"
  homepage "https://ratify.dev"
  url "https://github.com/notaryproject/ratify/archive/refs/tags/v1.4.9.tar.gz"
  sha256 "d899555e0961d92a656921b6387dd9f928cab179c95f2c68359f5067c46dfb55"
  license "Apache-2.0"
  head "https://github.com/notaryproject/ratify.git", branch: "main"

  # Upstream moves the tag until a release is finally made and marked as latest,
  # so we have to use the `GithubLatest` strategy to avoid picking up a pre-release.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "0fb3dec1b954d320359ee247a092f67b0a6074338f44de13725205e555c32a98"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1072de7c4e5ac1872f25ff98a304ef9e852238636febbb4b16c1f5eae4d71f10"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c0a446ee4ed0f4f08c12b5332b2bf1c619cc7a7dcecf997bd60075937d670a63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "26c234d4ec108b42f7d8924221542a370e9eae3239c83e2d68d8f554a2ecc215"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8e5013fb806a483a9cfc686f44ba51a8fb7da7ee84b264fefa89e25e76893bed"
    sha256 cellar: :any,                 x86_64_linux:      "8ab9f324bbfee1ad8d32713dd786f666e259a5664e379c342811ffcf675653db"
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
