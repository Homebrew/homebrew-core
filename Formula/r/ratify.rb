class Ratify < Formula
  desc "Artifact Ratification Framework"
  homepage "https://ratify.dev"
  url "https://github.com/notaryproject/ratify/archive/refs/tags/v1.4.7.tar.gz"
  sha256 "f65b582b8ebc78c46391c125a94e6299687be61899b2096c459dc955ad6a2b39"
  license "Apache-2.0"
  head "https://github.com/notaryproject/ratify.git", branch: "main"

  # Upstream moves the tag until a release is finally made and marked as latest,
  # so we have to use the `GithubLatest` strategy to avoid picking up a pre-release.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6bac6fb09d0f64c1a6c6174668f1c07f2b4551a59fee172d430cb68c91ea0566"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "73018e2bf7ed2ff15718015265edb4a5c81b58905a57fa8f19fa4e85f4533604"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6d14e1e19bfb6c2119d4f040d11e47a5ba60fce6965559ce25950cf7bdc09978"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c09c3059bd0eac9cd0bd8a2f56765ddd25876006708f3b421261f1ced9119b9b"
    sha256 cellar: :any,                 x86_64_linux:      "3bc2b4c1f2a56688ab0e5674d29d94ce3fff7d1b17a3a9990c0dbbfa1c92538e"
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
