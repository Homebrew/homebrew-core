class Ratify < Formula
  desc "Artifact Ratification Framework"
  homepage "https://ratify.dev"
  url "https://github.com/notaryproject/ratify/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "08458f51a3e95f55e470f3ed91cec28345356fb3393e7555bc79d08f98906003"
  license "Apache-2.0"
  head "https://github.com/notaryproject/ratify.git", branch: "main"

  # Upstream moves the tag until a release is finally made and marked as latest,
  # so we have to use the `GithubLatest` strategy to avoid picking up a pre-release.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92c3e1f594c70dc816abf7b24e91a73e2feccad35adf5673b1e4022431bd97a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1c65d827c53793e1a8bd0078ffe99c6b55fe023abc3daafba83782481c6d26f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f55d8f731af55dc89a15beed95c0766d60dd5ed095a54193078a552e49b3889d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac01292368f54e1c6f7bf4eb161c2d63a3226720222dd157959897b71c07bd1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b817e6233981b76ba270ad7d22d0e49585f800a4cd473bde3a74eee4dae0409"
    sha256 cellar: :any,                 x86_64_linux:  "bdca8caa5e4f8adfaff8244d57eca285a60e9d6029b10b8aa2f52b8cd2f7e19e"
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
