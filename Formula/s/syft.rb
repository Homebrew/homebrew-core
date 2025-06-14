class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.27.1.tar.gz"
  sha256 "8ee235ba5c28e51a153101b68ec58ff8a7f1a821628a3dc6ad5773217ffc8e36"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1c68a503519092c6baa256d0a9a8ad378cc25d345c53047bb004208bec72cd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52c703e9f65a265e4c9b99b992d98a0096e51cc7845f88ce101a1ec7c7259260"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8127725c9e892e09175b0df0319124fb7b7cdc8499590edb8bf2fe1ab0b2ac26"
    sha256 cellar: :any_skip_relocation, sonoma:        "113ec61e0eb16c6b3d363aa783f08f93a682371da752bd26205f46b242c9210f"
    sha256 cellar: :any_skip_relocation, ventura:       "3ee05b7b2b63690f977509e6310203cf40cde9befc3cc07066e6d81a73e98ade"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fa110a5eee2f9baf7e70c4dbbff2d240af1e58a1630fb092da40b89507a1442"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97c0efbd87c5059353706bedef60db471e88e5dee8c3243f10069d436f2f0987"
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
