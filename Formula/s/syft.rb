class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.44.0.tar.gz"
  sha256 "cbb7a58e179901a3bc678e740a71cab9cd5558dd3bddea74f6c4edf4592e8a98"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "386ca8af733f7650ecc7cf0a1e98cc1fbc0e94407edade978beb23d735949011"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "579b99d4a2143538dc1bcfa272161d3b413d15697b542de24817addaf968428e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "732db9e3ec3e20a11420cb3a88382c1f9546191ba74d711d6b3576520543141e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8ccd8e9fadc44f6da0ee994df2c3db5314dd4ce63aa33d5be806f7d2a33cd74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41e8b81cd885c48c39dc13d2e7e08b794cf46d188b4f7ead91a5087e8d1e75de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9821ca4bcf1db5b5ac5a0c7dc9b3f157036bb504f9eb91b2b8e0fd7cd9f708dd"
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

    generate_completions_from_executable(bin/"syft", shell_parameter_format: :cobra)
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
