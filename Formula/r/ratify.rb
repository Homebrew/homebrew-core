class Ratify < Formula
  desc "Artifact Ratification Framework"
  homepage "https://ratify.dev"
  url "https://github.com/ratify-project/ratify/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "ee4298819a6d72d1d35b2ee6ba52221800099ce88c360efd8a31d751027f6b35"
  license "Apache-2.0"
  head "https://github.com/ratify-project/ratify.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03d7fa6ea0483779ecd438b37ad4abf4e5b79bf813191fa38b351b4e724d9208"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03d7fa6ea0483779ecd438b37ad4abf4e5b79bf813191fa38b351b4e724d9208"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03d7fa6ea0483779ecd438b37ad4abf4e5b79bf813191fa38b351b4e724d9208"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bcf40d7cb491db9b40ef4264699b440acf5806f20bad0f2ee1a9333f93a74ed"
    sha256 cellar: :any_skip_relocation, ventura:       "b04d93460c9b39d6541ee0c0e3a7bc93170f09b4008b72a66ea8ec97d37dc099"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17f651e142921c2f9ae135a1bdcffc39bf0b8b55b1a4622beab5da1ff183aa09"
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
