class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.79.0",
      revision: "b2b332e8b2b66af0905e98b54ebd713a922be1a8"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92e5b498cb2858eae06c61494e3908abaade4f3c40a4fd048bf35a58ae3efcc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40dc57bf95a181c908ff525acc8e66a47e901ea48d697d31589269e7355b7639"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f00e5acd705247f97e7ed77dac808fcc5ed31263223b8a5f87b2f1fff1a146c7"
    sha256 cellar: :any_skip_relocation, ventura:        "1002afe0e68ea1ee461491550720ee0b374cc9d3afd1404553dff92647634b2f"
    sha256 cellar: :any_skip_relocation, monterey:       "9c1374368a0ca035513062cc82135a8727b5279a8044edd9d176591d62aac2a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "42f22f69db08da510008c33bfd54ab536814e2bbbc381a4ae09607cd4d042ab2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69d8ca154d82490c2a0bd3c3f30cc77b064961af38a56ef950a39377690f9e55"
  end

  depends_on "go" => :build

  resource "homebrew-micronaut.cdx.json" do
    url "https://raw.githubusercontent.com/anchore/syft/934644232ab115b2518acdb5d240ae31aaf55989/syft/pkg/cataloger/java/test-fixtures/graalvm-sbom/micronaut.json"
    sha256 "c09171c53d83db5de5f2b9bdfada33d242ebf7ff9808ad2bd1343754406ad44e"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/anchore/syft/internal/version.version=#{version}
      -X github.com/anchore/syft/internal/version.gitCommit=#{Utils.git_head}
      -X github.com/anchore/syft/internal/version.buildDate=#{time.iso8601}
    ]

    # Building for OSX with -extldflags "-static" results in the error:
    # ld: library not found for -lcrt0.o
    # This is because static builds are only possible if all libraries
    ldflags << "-linkmode \"external\" -extldflags \"-static\"" if OS.linux?

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/syft"

    generate_completions_from_executable(bin/"syft", "completion")
  end

  test do
    testpath.install resource("homebrew-micronaut.cdx.json")
    output = shell_output("#{bin}/syft convert #{testpath}/micronaut.json")
    assert_match "netty-codec-http2  4.1.73.Final  UnknownPackage", output

    assert_match version.to_s, shell_output("#{bin}/syft --version")
  end
end
