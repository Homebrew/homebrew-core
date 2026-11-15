class Ratify < Formula
  desc "Artifact Ratification Framework"
  homepage "https://ratify.dev"
  url "https://github.com/notaryproject/ratify/archive/refs/tags/v1.4.8.tar.gz"
  sha256 "c2ecdb37ee6b2fd8128003ad47ebe7ef0a9766379ebc7ff83b999b7ea90e06cb"
  license "Apache-2.0"
  head "https://github.com/notaryproject/ratify.git", branch: "main"

  # Upstream moves the tag until a release is finally made and marked as latest,
  # so we have to use the `GithubLatest` strategy to avoid picking up a pre-release.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "17c5d7c13787bf5d34b20bb60f69da4fdbd4d74753fbae759d6c388a867efbcc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ede6ebddd54e6511ff76997353049abac83be0eb91b80ad2a6541518c9c3a4ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "07236f83be05ce8606bc920d687603d120528c997724a52180a3a152e4208dd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "94b992e4d5fdb0422a62c884509b7424ac84c75f77153d78981ca6478cb1ce5e"
    sha256 cellar: :any,                 x86_64_linux:      "8f559bafd0034579f63391f6cc9277501b9bf2500bfc06be30b39c8b47a2f350"
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
