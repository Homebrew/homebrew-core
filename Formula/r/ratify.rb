class Ratify < Formula
  desc "Artifact Ratification Framework"
  homepage "https://ratify.dev"
  url "https://github.com/ratify-project/ratify/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "ada5c3a3c453a0552c287d0979534fb3c708bd8f41fdec83dc5378520626e339"
  license "Apache-2.0"
  head "https://github.com/ratify-project/ratify.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e288bb20adfce4de29b56e39519eb0a46aef9c63f8ac9a99495d30c775fcba3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e288bb20adfce4de29b56e39519eb0a46aef9c63f8ac9a99495d30c775fcba3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e288bb20adfce4de29b56e39519eb0a46aef9c63f8ac9a99495d30c775fcba3"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdc911061d14b31045fcb8a24564bbb131ba1faaa9ad7de05059e682c1e54395"
    sha256 cellar: :any_skip_relocation, ventura:       "0818e5ce845caafbdf43d5559e20a723d13b015bcc54ba2945dd1e4ba92be846"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71644e4fbc5f83bf238d1ea71cdd2a2e607089e614b7e109febce75c2adcdead"
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
