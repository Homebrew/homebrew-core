class Ratify < Formula
  desc "Artifact Ratification Framework"
  homepage "https://ratify.dev"
  url "https://github.com/notaryproject/ratify/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "36b18d2070d76a6e85aa86bf94e4e68350c6c277985d6bc8e87a28c78ebb08b8"
  license "Apache-2.0"
  head "https://github.com/notaryproject/ratify.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a1cda0ae27107972d8a38ab2920ea3a8aaeada5389a9025c4499bc761a5bab8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76678d359f1e6ab18b91b1703a44b6171e3a03d200a41db6a7d3568a9727b334"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76678d359f1e6ab18b91b1703a44b6171e3a03d200a41db6a7d3568a9727b334"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76678d359f1e6ab18b91b1703a44b6171e3a03d200a41db6a7d3568a9727b334"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f8913f574364f7b1f4269e539bfe4b1ff128bf4ef3266c2c46c5121fc9132e9"
    sha256 cellar: :any_skip_relocation, ventura:       "d446ade57aad5022820d43cff3e52206a2521189ea30fe1f39ba198d4789977d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec3bab691e984cc0fc73aae4bd8143a39affc203ef6baa5ecdb242d943465235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e76330b293fc305772b44b705cc2d7700100276bb27981382984fa474824c851"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ratify-project/ratify/internal/version.GitTag=#{version}
      -X github.com/ratify-project/ratify/internal/version.GitCommitHash=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/ratify"

    generate_completions_from_executable(bin/"ratify", "completion")
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
