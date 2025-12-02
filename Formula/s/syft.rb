class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.38.0.tar.gz"
  sha256 "56131747bc5cd01475ceced9289f6fb527ccd40bc0cb5ff9f528bb04604638eb"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc0124774c1c001cf0132639e1dbd5d453016fce60bf5da01b087584698f7d67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89f74e35a6e4596d982c1858093f8a183c1e736a33507c6e03d96a02775e1454"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "836e37278a688b0e55dc6e1220a4c61ab883a747b029c211831dc986ad2723a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "00220d51c3e7e229733d11eeda860fabdcbd9de6a15cc1f932b5e06e3381fbf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09581e293d83a9aa980889135ebc3d1e6dcadfb5d6ee42a679dc4c562c03dcfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6761203652cbd28475ed26a647794bddec1a4bef6ecb503a3718a519ce6f932"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/syft"

    generate_completions_from_executable(bin/"syft", "completion")
  end

  test do
    resource "homebrew-micronaut.cdx.json" do
      url "https://raw.githubusercontent.com/anchore/syft/934644232ab115b2518acdb5d240ae31aaf55989/syft/pkg/cataloger/java/test-fixtures/graalvm-sbom/micronaut.json"
      sha256 "c09171c53d83db5de5f2b9bdfada33d242ebf7ff9808ad2bd1343754406ad44e"
    end

    testpath.install resource("homebrew-micronaut.cdx.json")
    output = shell_output("#{bin}/syft convert #{testpath}/micronaut.json")
    assert_match "netty-codec-http2  4.1.73.Final  UnknownPackage", output

    assert_match version.to_s, shell_output("#{bin}/syft --version")
  end
end
