class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.57.2.tar.gz"
  sha256 "1cf84a0b5481cc9b6bfa158e2cf1f51a69f4b3d2da1bb79be25511891f2dc473"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    manifest_sha256 "51d30793dc80b4bccf31e954916844ff1a3548d41b7700a61c95c30e2917b72f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "70721ae6c9bf3322376a3f4e9fe65909c62660add6881a9fcd8de32806674cae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c9ec6042ce272929d37a0e905e130e86ec8635192498bfb09aa0f87708598e58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "adb8f493455d9625cb32718a82a84f3271961099a3ee8f458ec37f9823aeed4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e7d484ed13fb4742a76b46fa4f9224f7442fe9a7caa97e1288d3ba4ad6595ffd"
    sha256 cellar: :any,                 x86_64_linux:      "af00e00baae56bef0cb3eaba243a828fa84edc1e6f48fb00d03604da094f6ed7"
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
