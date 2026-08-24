class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.51.0.tar.gz"
  sha256 "d48bca3091ec4862f5041af6cbdeedb3f2322ae7a059199a22d99e099cabd4ae"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37aa3d3abaee265b2cea65f50f4269eee65c71137e37cf24b2fab1b52c49c431"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bd16589eca221710588572088897f9bcecdf8366ad3141e794df5b87a9e4641"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae9c4a780f8f378cb2bf1ef3d40386e7bc2d50f867b4ab55ea0232572c870a88"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf7bfdad9a11b00032def27afd6fbd2f6f9dda0e1a5e1e26096cd9b6c53c06fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecc19889369004d514e13e79dd1bb297fb0bd071909bb4a1331282ead7e1fc3b"
    sha256 cellar: :any,                 x86_64_linux:  "4e0a5066e8ec542936f935771d8cd622dbbb68c413e4be2d0e7c82c8fe2fb319"
  end

  depends_on "go" => :build

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
    output = shell_output("#{bin}/syft convert #{testpath}/micronaut.json")
    assert_match "netty-codec-http2  4.1.73.Final  UnknownPackage", output

    assert_match version.to_s, shell_output("#{bin}/syft --version")
  end
end
