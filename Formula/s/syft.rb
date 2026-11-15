class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.57.1.tar.gz"
  sha256 "990a7d9402109bce18f27c54a15ac5c10ac6f05e559a2f576aaa5c70afbaeab4"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1a743d66c4c29eaa1044f1360715fa5b81f5ec9cab3a93935338c58dc2ff2e82"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "09b6005a5029c8106949f4b252649757a6076349ceca44e1f205dc29b34c99f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a9fb73f40e66f9a20d0d2ad993e988a87db21840495a38586207186d4007642e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8f3d51264732a79d229fc7038e29471a91e8cdc65ee423e5c0d11c2e57524bc0"
    sha256 cellar: :any,                 x86_64_linux:      "d712ff8f6d39850759d708f5a1e63b39a05c8bbb3e822ba1719dbc8f85ddf59a"
  end

  depends_on "go" => :build

  resource "homebrew-micronaut.cdx.json", :test do
    url "https://raw.githubusercontent.com/anchore/syft/934644232ab115b2518acdb5d240ae31aaf55989/syft/pkg/cataloger/java/test-fixtures/graalvm-sbom/micronaut.json"
    sha256 "c09171c53d83db5de5f2b9bdfada33d242ebf7ff9808ad2bd1343754406ad44e"
  end

  # `test do` block downloads a test fixture resource
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/syft"

    generate_completions_from_executable(bin/"syft", shell_parameter_format: :cobra)
  end

  test do
    testpath.install resource("homebrew-micronaut.cdx.json")
    # Redirect stderr so the progress UI does not engage on the sandbox PTY and hang
    output = shell_output("#{bin}/syft convert #{testpath}/micronaut.json 2>/dev/null")
    assert_match "netty-codec-http2  4.1.73.Final  UnknownPackage", output

    assert_match version.to_s, shell_output("#{bin}/syft --version")
  end
end
