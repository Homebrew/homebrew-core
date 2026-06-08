class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.45.1.tar.gz"
  sha256 "eeae4dceb6d3efded3a7209da5d051bfcba9387dbe15722f22bde5f90eb2200d"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7a72bf67f4afd3c73172116ac92fab762a8fb78e1c9f8f0f7a9e37c516f3181"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d200289f5ea3fa1a7ce795ac496afb0eb1fc967cae41d33d632dfd0fd7aa2a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "305764231ae21b662f1148aa8f890de1363d1fcd3612e9a51328a44586a3fbe0"
    sha256 cellar: :any_skip_relocation, sonoma:        "087fce301b22657c00ea9c34ffd4d4cb7daa00d37e9281a09dab92ac55838bb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8585733dfcb9991c770e256f9282126c8c776fdf581192311d1b36600ccf200f"
    sha256 cellar: :any,                 x86_64_linux:  "69dd10bc17d4a8dcc49c8a5c33fa7ff187a13b0472dd0a72d14558b107afa306"
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
