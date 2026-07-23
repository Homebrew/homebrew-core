class Ratify < Formula
  desc "Artifact Ratification Framework"
  homepage "https://ratify.dev"
  url "https://github.com/notaryproject/ratify/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "86ff9fdc0c1922298738363d4e89c99969ecd27e5eab5988d3409ec6e8102db6"
  license "Apache-2.0"
  head "https://github.com/notaryproject/ratify.git", branch: "main"

  # Upstream moves the tag until a release is finally made and marked as latest,
  # so we have to use the `GithubLatest` strategy to avoid picking up a pre-release.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cd75dbe9962fb28d54aecc2772d0e937b35b6d920d4869fe947c3442299e06e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1191698f56e069c13779e17630725c593386b7411e7ae474b003dadb8944cdd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d21da889107c94e08faa91134f375bc3bd8e13d2251613e1d7835b7edc2f183"
    sha256 cellar: :any_skip_relocation, sonoma:        "f14cb9b7b319d12a70e20123bd9136744efdcce459c1d2c94251995ecce7c4eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48bf389165d47ff6e618723d28242666c97c13d2ffd1ebc2ccaf49cf17b024dc"
    sha256 cellar: :any,                 x86_64_linux:  "4bb660ec7c3f696500f87376f87f987ee3436151c075219d2b6b47363219364f"
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
