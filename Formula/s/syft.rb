class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.52.0.tar.gz"
  sha256 "8b999a1b8bd08b12512176cdec5d063db9cfe209c65cc5de9c4eb2ab7bdc7b3c"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "46fdc2094d0457d61857fd79edd713d869a51f0c2fb36e486f6e661b4fc9b9b4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "20dc2da9c4a1e00a7737eb8ecc9cfee332abe845a1f9655339799ba8e0c2fcbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "feab2969b8b47e0e97a58e3719442e1aeed8b78e2d3d905ffa780f56f4f40368"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0c17a51ba1b8bbbc69db5bf8f3cfd4af1dd421e1b46313f32b35c00218e0ff4e"
    sha256 cellar: :any,                 x86_64_linux:      "952f0ea73a2190e99e5f3e80372c28b13d5318ba1f95f0fe3d9a693ec515cd55"
  end

  depends_on "go" => :build

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
    resource "homebrew-micronaut.cdx.json" do
      url "https://raw.githubusercontent.com/anchore/syft/934644232ab115b2518acdb5d240ae31aaf55989/syft/pkg/cataloger/java/test-fixtures/graalvm-sbom/micronaut.json"
      sha256 "c09171c53d83db5de5f2b9bdfada33d242ebf7ff9808ad2bd1343754406ad44e"
    end

    testpath.install resource("homebrew-micronaut.cdx.json")
    # Redirect stderr so the progress UI does not engage on the sandbox PTY and hang
    output = shell_output("#{bin}/syft convert #{testpath}/micronaut.json 2>/dev/null")
    assert_match "netty-codec-http2  4.1.73.Final  UnknownPackage", output

    assert_match version.to_s, shell_output("#{bin}/syft --version")
  end
end
