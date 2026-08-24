class Ratify < Formula
  desc "Artifact Ratification Framework"
  homepage "https://ratify.dev"
  url "https://github.com/notaryproject/ratify/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "82b05fc373327e71495cbec472afd2eec81e08a30b472e2c634eda507d3baa00"
  license "Apache-2.0"
  head "https://github.com/notaryproject/ratify.git", branch: "main"

  # Upstream moves the tag until a release is finally made and marked as latest,
  # so we have to use the `GithubLatest` strategy to avoid picking up a pre-release.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "138ff2891fc6d28cffa3afc63552d7800abdcf7ac5e3b943f6c4c50712554dc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bccb8c1b10b819dece823328d6bc546aa2d7199f3947bb480a4f65932739e065"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b41d9dae5ef28639388da97e914ccc17515d1726dd36e1e41868dc978f03d354"
    sha256 cellar: :any_skip_relocation, sonoma:        "573b841032f0500c9d80c9fec0e5d323a7ab17fd90616a5719f087b1c0570301"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e0d4355b3d54e5e99f6f33aa50ed324c962a91e4f4ae2281e64070934c78ee3"
    sha256 cellar: :any,                 x86_64_linux:  "9ad4310af1f42945f2b52f78991a0a2efefecc9dba064a9f6d38793f8a100a8a"
  end

  depends_on "go" => :build

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
