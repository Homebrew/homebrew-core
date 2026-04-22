class Ratify < Formula
  desc "Artifact Ratification Framework"
  homepage "https://ratify.dev"
  url "https://github.com/notaryproject/ratify/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "58db052b8a02a7d5cc78dde837530c5d7fe0f525facd84d8aac4ef7ab93f5ce2"
  license "Apache-2.0"
  head "https://github.com/notaryproject/ratify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fdbdf1f9e1245d66cdb6dfda5362bba5dd3f1b826f76100604b8d94a7e47e17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b52b32cd9d05985a26682e45778cb96350625b7fb6bbee7b1d9727e9c1a98690"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33e9edfb4e23350e884ed0b1cec13e68b3fe9f723a35323bf4f7863c05cf3ebb"
    sha256 cellar: :any_skip_relocation, sonoma:        "681c43566783f430dcf3a6ac6ed88956c579e6e62e83843607d15ce7dc5a413c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27a457749e095c1d67637103a5e9d492963d098f4cd41a667f2723aae843771e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95c21492f783fb26e8c404033a3a71ce79ad3c01db421c1dc69e5f71bd98ad09"
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
