class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "40f0780a72245e77c72c7ab196c7a55ddba16430e9b4a4e48cf4002b46ca4283"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5de8561066841da2ad138d44501f9d2e9583d5d2ce46fb32377d5d4b8faa3940"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16d353521cacddf6993ba7a2a8e6888a8e59ef0db62c35018d23920b8bbccda1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3abd4f99c81bd381f855c77215167d047b31a5875c4be7ba47dd3c71ca964bcf"
    sha256 cellar: :any_skip_relocation, sonoma:        "f313bacbade07c71094fee9593751ca7dcae570731e8200002549549bd317683"
    sha256 cellar: :any_skip_relocation, ventura:       "329a4e5e53d1be60755478bdacf313794527ee010bcf60d9c579b7beb9c9743b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c10a9d3cadd4a2814051778341a6c1feb74e516d29bfd0ab3f7b790ea0cd5bb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "163d3d50e0d4c99207a5fc0421047874fdcb2c34b9ed9ba7ba311e4de38b5da2"
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
