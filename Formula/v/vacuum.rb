class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.23.2.tar.gz"
  sha256 "d81159ceaaaf27bcc008e8b3806c66c9a5108be45c63b6c93e0077ee21ab036e"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16277cae322ccd59d4649641fd6054d628d6a1f93a62f79ad1030130e14d23e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af45c3b057de8e39b90878e07f254ce0b1ec9e596c08c0ad0d979f102c0edf7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c680901a19e6be8bfa26f6c81ccc5242b025c8ece6a5fa7166d5420ad61d7619"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4cc4be2e45f5fa3611b5e1fe56abb6d278f773829e52d05d8f11c6c4e6c6b39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fdd1f5cbe26681c5b88a884068d809d0d93c9bd6dd0b78590eea3827a166d0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f639b02546bc87c1d98b83c9b1f7c6959f11cea22ee7f7ea59b5d2c3567f28e4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vacuum", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vacuum version")

    (testpath/"test-openapi.yml").write <<~YAML
      openapi: 3.0.0
      info:
        title: Test API
        version: 1.0.0
      paths:
        /test:
          get:
            responses:
              '200':
                description: Successful response
    YAML

    output = shell_output("#{bin}/vacuum lint #{testpath}/test-openapi.yml 2>&1", 1)
    assert_match "Failed with 2 errors, 3 warnings and 0 informs.", output
  end
end
