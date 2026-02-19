class Ratify < Formula
  desc "Artifact Ratification Framework"
  homepage "https://ratify.dev"
  url "https://github.com/notaryproject/ratify/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "36b18d2070d76a6e85aa86bf94e4e68350c6c277985d6bc8e87a28c78ebb08b8"
  license "Apache-2.0"
  head "https://github.com/notaryproject/ratify.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbfe26dfff4f2a07fced8068c4f310e4b55659471170ce553cc492722d2eb373"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbfe26dfff4f2a07fced8068c4f310e4b55659471170ce553cc492722d2eb373"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbfe26dfff4f2a07fced8068c4f310e4b55659471170ce553cc492722d2eb373"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0b76073c6c99a14be4c1b896125d8240e046dcb8f02a4ec7cf37bad433f7402"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75e335cb5b00d9242f32d899d2ad01236a84e505f29416a4e8bb1c6e67d3dd53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7cdee30bc6f418af0a3bc8ca809718968ec940199d0c399f7088f0f80bdfd03"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
